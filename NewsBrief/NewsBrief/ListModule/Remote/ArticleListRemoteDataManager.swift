//
//  ArticleListRemoteDataManager.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 27/04/21.
//

import Foundation

/// This class performs the Network call to fetch Article List Data
class ArticleListRemoteDataManager: ArticleListRemoteInputProtocol {
    
    var remoteRequestHandler: ArticleListRemoteOutputProtocol?
    
    private var pageSize: String?
    private var currentPage: String?
    
    /// This function fetches Article Details from Remote
    func retrieveArticleDetails(forPageSize pageSize: String?, andCurrentPage currentPage: String?) {
        
        if NetworkReachabilityManager.shared.connectedToNetwork() {
            self.pageSize = pageSize
            self.currentPage = currentPage
            performArticleDetailsFetch()
        } else {
            self.remoteRequestHandler?.onError(withError: ErrorMessages.noInternet)
        }
    }
    
    /// This function fetches Article Image Details from Remote
    func retrieveArticleImages(forArticleUrls urls: [String?]) {
        
        self.downloadImage(withUrls: urls) { (success) in
            
            self.remoteRequestHandler?.onArticleImagesRetrieved(imageDataArray: success, forArticleUrls: urls)
            
        } failure: { [weak self] (error) in
            self?.remoteRequestHandler?.onError(withError: ErrorMessages.noArticlesFound)
        }
    }
    
    /// This function is used to perform fetch task
    private func performArticleDetailsFetch() {
        
        /// ArticleDetails Task, Fetching 30 Items per page
        let articleDetailsTask = GetArticleDetailsTask(apiKey: Api.key, country: ParamKeys.us, category: ParamKeys.business, pageSize: self.pageSize ?? "0", page: self.currentPage ?? StringConstants.empty)
        
        /// Dispatcher instance to dispatch tasks
        let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.baseUrl))
        
        articleDetailsTask.execute(in: dispatcher) { [weak self] (json) in
            
            DispatchQueue.main.async { [self] in
                
                /// Parsing the Response Object
                if let jsonData = json as? [String: AnyObject],
                   let totalResults = jsonData[JSONKeys.totalResults] as? Int,
                   let articles = jsonData[JSONKeys.articles] as? [AnyObject] {
                    
                    /// Collecting the Article Response for the page requested
                    var articleResponse: [ArticleModel] = []
                    for article in articles {
                        if let article = article as? [String: AnyObject] {
                            let newArticle = ArticleModel(jsonData: article)
                            articleResponse.append(newArticle)
                        }
                    }
                    
                    self?.remoteRequestHandler?.onArticleDetailsRetrieved(totalCount: totalResults, articleDataModel: articleResponse)
                }
            }
        } failure: { [weak self] (error) in
            self?.remoteRequestHandler?.onError(withError: ErrorMessages.noArticlesFound)
        }
    }
    
    /// This function is used to download the images associated with the current page
    ///
    /// - Parameters:
    ///   - urls: The image urls for the current page
    ///   - success: Success Block
    ///   - failure: Failure Block
    func downloadImage(withUrls urls: [String?], success: @escaping (([Data?]) -> Void),
                       failure: @escaping ((Error?) -> Void)) {
        
        /// Dispatch group is used to perform concurrent fetch of all the image Data for a given Page
        let group = DispatchGroup()
        
        var imageDataArray = [Data?].init(repeating: nil, count: urls.count)
        
        for index in 0..<urls.count {
            
            guard let url = urls[index] else {
                continue
            }
            
            /// Entering the Group
            group.enter()
            
            let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: url))
            let attachmentDownloadTask = DownloadAttachmentDataTask(path: StringConstants.empty)
            attachmentDownloadTask.execute(in: dispatcher) { (data) in
                
                if let data = data as? Data {
                    imageDataArray[index] = data
                    /// Leaving the group after download is successful
                    group.leave()
                }
                
            } failure: { (error) in
                NSLog("Could not download the image for \(String(describing: index))")
                
                /// Leaving the group if the download fails
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            /// returning the image data array after the downloads are complete
            success(imageDataArray)
        }
    }
}
