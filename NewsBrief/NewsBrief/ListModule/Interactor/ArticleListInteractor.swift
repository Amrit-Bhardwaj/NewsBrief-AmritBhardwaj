//
//  ArticleListInteractor.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 'ArticleListInteractor' handles the business logic for Article List View
 */
final class ArticleListInteractor {
    
    var presenter: ArticleListInteractorToPresenterProtocol?
    var databaseManager: DatabaseManagerProtocol?
    var fileManager: FileManagerProtocol?
    
    private var articles: [ArticleModel] = []
    
    /// Current Page to be downloaded
    private var currentPage = 1
    
    /// Total Results to download
    private var total = 0
    
    /// Fetch Progress Indicator
    private var isFetchInProgress = false
    
    /// Page Size to Fetch
    private var pageSize = "30"
    
    /// Current count of articles downloaded
    private var currentCount: Int {
        return articles.count
    }
    
    /// This function is used to return article at a given index
    ///
    /// - Parameters:
    ///   - index: The index for which to get article data
    
    /// - Returns: Article Data at the given index
    func article(at index: Int) -> ArticleModel {
        return articles[index]
    }
    
    // TODO: - We can also use an Operation Queue and enqueue the two tasks and set dependency
    
    /// This function is used to fetch the Article Details from remote
    func fetchArticleDetails() {
        performFetch()
    }
    
    /// This function is used to perform fetch task
    private func performFetch() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        /// ArticleDetails Task, Fetching 30 Items per page
        let articleDetailsTask = GetArticleDetailsTask(apiKey: Api.key, country: ParamKeys.us, category: ParamKeys.business, pageSize: self.pageSize, page: String(self.currentPage))
        
        /// Dispatcher instance to dispatch tasks
        let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.baseUrl))
        
        articleDetailsTask.execute(in: dispatcher) { [weak self] (json) in
            
            DispatchQueue.main.async { [self] in
                
                /// Incrementing the Current page count after previous page is downloaded
                self?.currentPage += 1
                self?.isFetchInProgress = false
                
                /// Parsing the Response Object
                if let jsonData = json as? [String: AnyObject],
                   let totalResults = jsonData[JSONKeys.totalResults] as? Int,
                   let articles = jsonData[JSONKeys.articles] as? [AnyObject] {
                    
                    /// Setting the total Results count
                    self?.total = totalResults
                    
                    /// Collecting the Article Response for the page requested
                    var articleResponse: [ArticleModel] = []
                    for article in articles {
                        if let article = article as? [String: AnyObject] {
                            let newArticle = ArticleModel(jsonData: article)
                            articleResponse.append(newArticle)
                        }
                    }
                    
                    /// Retrieving the article Image Urls for each article response
                    var articleUrls: [String?] = []
                    for responseItem in articleResponse {
                        articleUrls.append(responseItem.urlToImage)
                    }
                    
                    /// Performing the Download of all the images for the current page
                    self?.downloadImage(withUrls: articleUrls) { (success) in
                        
                        /// Setting the image Data to the response Objects
                        for index in 0..<articleResponse.count {
                            articleResponse[index].imageData = success[index]
                        }
                        
                        self?.articles.append(contentsOf: articleResponse)
                        
                        /// If the current page is not the first one, we calculate indexPath to reload
                        if let currentPage = self?.currentPage, currentPage > 2 {
                            let indexPathsToReload = self?.calculateIndexPathsToReload(from: articleResponse)
                            
                            self?.presenter?.onFetchCompleted(with: indexPathsToReload)
                            
                        } else {
                            self?.presenter?.onFetchCompleted(with: .none)
                        }
                        
                    } failure: { (error) in
                        self?.presenter?.onFetchFailed()
                    }
                }
            }
            
        } failure: { [weak self] (error) in
            self?.isFetchInProgress = false
            self?.presenter?.onFetchFailed()
        }
    }
    
    /// This function is used to calculate the IndexPaths for which we need to reload the data on the view
    ///
    /// - Parameters:
    ///   - newArticles: New Articles fetched
    /// - Returns: Array of indexPaths to reload
    private func calculateIndexPathsToReload(from newArticles: [ArticleModel]) -> [IndexPath] {
        let startIndex = articles.count - newArticles.count
        let endIndex = startIndex + newArticles.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    /// This function is used to download the images associated with the current page
    ///
    /// - Parameters:
    ///   - urls: The image urls for the current page
    ///   - success: Success Block
    ///   - failure: Failure Block
    private func downloadImage(withUrls urls: [String?], success: @escaping (([Data?]) -> Void),
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
                    
                    /// Saving the fetched image to fileSystem, FileName is the Hash of the Url, We can use other hashing to set the filename uniquely
                    self.saveToFileSystem(withFileName: String(url.hash), fileData: data)
                    
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
    
    /// This function is used to save the data with the fileName into FileSystem
    ///
    /// - Parameters:
    ///   - name: File name
    ///   - fileData: file Data
    private func saveToFileSystem(withFileName name: String, fileData: Data) {
        fileManager?.save(fileName: name, file: fileData)
    }
    
    /// This function is used to create Article ID from the Article Url
    ///
    /// - Parameters:
    ///   - url: Article Url
    /// - Returns: Article ID
    private func articleId(fromUrl url: String?) -> String? {
        guard let url = url else {return nil}
        let replacedUrl = url.replacingOccurrences(of: StringConstants.forwardSlash, with: StringConstants.hyphen).split(separator: ":").last
        let articleId = replacedUrl?.components(separatedBy: StringConstants.doubleHyphen).joined()
        return articleId
    }
}

extension ArticleListInteractor: ArticleListPresenterToInteractorProtocol {
    
    /// This function is used to get the current Article Count
    /// - Returns: Article Count
    func getCurrentArticleCount() -> Int? {
        return currentCount
    }
    
    /// This function is used to get the total article count
    /// - Returns: Article ID
    func totalArticleCount() -> Int? {
        return total
    }
    
    /// This function is used to get the article Data at a given index
    ///
    /// - Parameters:
    ///   - index: index
    /// - Returns: Article Data
    func article(at index: Int) -> Article {
        
        let articleData = articles[index]
        let articleID = articleId(fromUrl: articleData.url)
        
        return Article(author: articleData.author, description: articleData.description, image: articleData.imageData, title: articleData.title, publishedDate: articleData.publishedAt, content: articleData.content, articleID: articleID)
    }
}
