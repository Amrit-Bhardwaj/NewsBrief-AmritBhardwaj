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
    var remoteDataManager: ArticleListRemoteInputProtocol?
    
    private var articles: [ArticleModel] = []
    
    /// Current Page to be downloaded
    private var currentPage = 1
    
    /// Total Results to download
    private var total = 0
    
    /// Fetch Progress Indicator
    private var isFetchInProgress = false
    
    /// Page Size to Fetch
    private var pageSize = "30"
    
    private var articleResponse: [ArticleModel] = []
    
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
        if NetworkReachabilityManager.shared.connectedToNetwork() {
            
            guard !isFetchInProgress else {
                return
            }
            
            isFetchInProgress = true
            
            remoteDataManager?.retrieveArticleDetails(forPageSize: self.pageSize, andCurrentPage: String(self.currentPage))
            
        } else {
            self.presenter?.onFetchFailed(withError: .noInternet)
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

extension ArticleListInteractor: ArticleListRemoteOutputProtocol {
    
    func onArticleDetailsRetrieved(totalCount count: Int, articleDataModel dataModel: [ArticleModel]) {
        
        /// Incrementing the Current page count after previous page is downloaded
        self.currentPage += 1
        self.isFetchInProgress = false
        self.total = count
        self.articleResponse = dataModel
        
        /// Retrieving the article Image Urls for each article response
        var articleUrls: [String?] = []
        for responseItem in dataModel {
            articleUrls.append(responseItem.urlToImage)
        }
        
        self.remoteDataManager?.retrieveArticleImages(forArticleUrls: articleUrls)
    }
    
    func onArticleImagesRetrieved(imageDataArray imageData: [Data?], forArticleUrls urls: [String?]) {
        
        /// Saving the fetched image to fileSystem, FileName is the Hash of the Url, We can use other hashing to set the filename uniquely
        for index in 0..<urls.count {
            self.saveToFileSystem(withFileName: urls[index] ?? StringConstants.empty, fileData: imageData[index] ?? Data())
        }
        
        /// Setting the image Data to the response Objects
        for index in 0..<articleResponse.count {
            articleResponse[index].imageData = imageData[index]
        }
        
        self.articles.append(contentsOf: articleResponse)
        
        /// If the current page is not the first one, we calculate indexPath to reload
        if self.currentPage > 2 {
            let indexPathsToReload = self.calculateIndexPathsToReload(from: articleResponse)
            
            self.presenter?.onFetchCompleted(with: indexPathsToReload)
            
        } else {
            self.presenter?.onFetchCompleted(with: .none)
        }
    }
    
    func onError(withError error: ErrorMessages) {
        self.isFetchInProgress = false
        self.presenter?.onFetchFailed(withError: .noArticlesFound)
    }
}
