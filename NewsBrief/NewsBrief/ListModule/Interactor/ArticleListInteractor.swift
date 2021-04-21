//
//  ArticleListInteractor.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListInteractor {
    
    var presenter: ArticleListInteractorToPresenterProtocol?
    var databaseManager: DatabaseManagerProtocol?
    var fileManager: FileManagerProtocol?
    
    private var articles: [ArticleModel] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    private var currentCount: Int {
        return articles.count
    }
    
    func article(at index: Int) -> ArticleModel {
        return articles[index]
    }
    
    //1. Fetch the Article details from news API, map it to ArticleModel and save the details to coredata entity
    //2. Download the image using the image url and save it to Application support directory with name+date as fileName
    
    // TODO: -  We can use an Operation Queue and enqueue the two tasks and set dependency
    // TODO: - using a Dispatch Group to perform concurrent download of images

     func fetchArticleDetails() {
        
        //Fetching the last entry in the dB, sorted based on date
        // We can improve the fetch using faulting and memory pruning
//        let dbEntry = databaseManager?.fetch()
//        let currenEffectiveDate = Date().effectiveCurrentDate().convertToLocalTime()
//
//
//        // Case 1: if network is reachable and dB does not have any entry for current Date, We trigger API call
//        if NetworkReachabilityManager.shared.connectedToNetwork() {
//
//            if dbEntry == nil || dbEntry?.0 != currenEffectiveDate {
//                performFetch()
//
//            } else {
//
//                // Case 4: when Internet is available and dB has entry for current Date, we show the image from directory
//                if let dBData = dbEntry, dBData.0 == currenEffectiveDate {
//
//                    let imageData = fileManager?.openFile(fileName: dBData.3!)
//                    self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//                }
//            }
//
//        } else {
//
//            // Case 2: if network is not reachable and dB has entry for current Date, we show the image from directory
//            if let dBData = dbEntry, dBData.0 == currenEffectiveDate {
//
//                let imageData = fileManager?.openFile(fileName: dBData.3!)
//                self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//            }
//
//            // Case 3: if network is not reachable and dB does not have an entry for current Date, fetch the last available entry in the dB and show its image from directory
//            if let dBData = dbEntry, dBData.0 != nil && dBData.0 != currenEffectiveDate {
//
//                let imageData = fileManager?.openFile(fileName: dBData.3!)
//                self.presenter?.imageFetchedSuccess(imageData: imageData!, title: dBData.1!, explanation: dBData.2!)
//
//            }
//
//            self.presenter?.imageFetchFailed()
//        }
        performFetch()
        
    }
    
    private func performFetch() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        // fetch 20 Items per page
        //1. page = 1, pageSize = 20, 20 image urls
        //2. page = 2, pagesSize = 20, image urls
        //3. page = 3, paegSize = 20
        //4. page = 4, paegSize = 10
        
        let articleDetailsTask = GetArticleDetailsTask(apiKey: Api.key, country: "us", category: "business", pageSize: "30", page: String(self.currentPage))
        
        let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.baseUrl))
        
        articleDetailsTask.execute(in: dispatcher) { [weak self] (json) in
            
            DispatchQueue.main.async { [self] in
                
                self?.currentPage += 1
                self?.isFetchInProgress = false
                
                if let jsonData = json as? [String: AnyObject],
                   let totalResults = jsonData["totalResults"] as? Int,
                   let articles = jsonData["articles"] as? [AnyObject] {
                    
                    self?.total = totalResults
                    var articleResponse: [ArticleModel] = []
                    for article in articles {
                        if let article = article as? [String: AnyObject] {
                            let newArticle = ArticleModel(jsonData: article)
                            articleResponse.append(newArticle)
                        }
                    }
                    
                    var articleUrls: [String?] = []
                    for responseItem in articleResponse {
                        articleUrls.append(responseItem.urlToImage)
                    }
                    
                    self?.downloadImage(withUrls: articleUrls) { (success) in
                        
                        for index in 0..<articleResponse.count {
                            articleResponse[index].imageData = success[index]
                        }
                        
                        self?.articles.append(contentsOf: articleResponse)
                        
                        if let currentPage = self?.currentPage, currentPage > 2 {
                            let indexPathsToReload = self?.calculateIndexPathsToReload(from: articleResponse)
                            self?.presenter?.onFetchCompleted(with: indexPathsToReload)
                            
                        } else {
                            self?.presenter?.onFetchCompleted(with: .none)
                        }
                        
                    } failure: { (error) in
                        self?.presenter?.imageFetchFailed()
                    }
                }
            }
            
            
            
//            if let imageUrl = articleModel.url {
//
//                let fileName = imageUrl.components(separatedBy: "//")[1].components(separatedBy: "/").last!
//
//                self?.downloadImage(withUrl: imageUrl, success: { (data) in
//
//                    // 1. Save the data to file system and return the image
//                    // 2. Make an entry to dB with the data
//
//                    if let data = data as? Data {
//                        DispatchQueue.main.async {
//
//                            self?.saveToFileSystem(withFileName: fileName, fileData: data)
//
//                            self?.saveTodB(attachmentData: articleModel)
//
//                            self?.presenter?.imageFetchedSuccess(imageData: data, title: articleModel.title!, explanation: articleModel.description!)
//                        }
//                    }
//
//                }, failure: { (error) in
//                    self?.presenter?.imageFetchFailed()
//                })
//            }
            
        } failure: { [weak self] (error) in
            self?.isFetchInProgress = false
            self?.presenter?.imageFetchFailed()
        }
    }
    
    private func calculateIndexPathsToReload(from newArticles: [ArticleModel]) -> [IndexPath] {
      let startIndex = articles.count - newArticles.count
      let endIndex = startIndex + newArticles.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    // Download the Attachment Data for the articles of a given Page
    private func downloadImage(withUrls urls: [String?], success: @escaping (([Data?]) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        let group = DispatchGroup()
        var imageDataArray = [Data?].init(repeating: nil, count: urls.count)
        for index in 0..<urls.count {
            
            guard let url = urls[index] else {
                continue
            }
            
            group.enter()
            let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: url))
            let attachmentDownloadTask = DownloadAttachmentDataTask(path: "")
            
            attachmentDownloadTask.execute(in: dispatcher) { (data) in
                    
                    if let data = data as? Data {
                        // TODO: - mapping image with article
                        imageDataArray[index] = data
                        self.saveToFileSystem(withFileName: String(url.hash), fileData: data)
                        group.leave()
                    }
                
            } failure: { (error) in
                NSLog("Could not download the image for \(String(describing: index))")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            success(imageDataArray)
        }
    }
    
    // Save the downloaded image to file System
    private func saveToFileSystem(withFileName name: String, fileData: Data) {
        fileManager?.save(fileName: name, file: fileData)
    }
    
    // Save the image details to dB
    private func saveTodB(attachmentData data: ArticleModel) {
        
        let fileName = data.url!.components(separatedBy: "//")[1].components(separatedBy: "/").last!
        
        let effectiveDate = (data.publishedAt?.toDateWithFormat(withFormat: "yyyy-MM-dd"))!.convertToLocalTime()
        
        databaseManager?.save(date: effectiveDate, explanation: data.description!, filePath: fileName, title: data.title!)
    }
}

extension ArticleListInteractor: ArticleListPresenterToInteractorProtocol {
    
    func getCurrentArticleCount() -> Int? {
        return currentCount
    }
    
    func totalArticleCount() -> Int? {
        return total
    }
    
    func article(at index: Int) -> Article {
        let articleData = articles[index]
        return Article(author: articleData.author, description: articleData.description, image: articleData.imageData, title: articleData.title, publishedDate: articleData.publishedAt, content: articleData.content)
    }
}
