//
//  ArticleDetailsProtocols.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import Foundation

// This file consists of all the protocols used throughout the Article List Module
// Passing simple native data type as params for communication between layers to avoid dependency
protocol ArticleDetailsViewToPresenterProtocol: class {
    
    var view: ArticleDetailsPresenterToViewProtocol? {get set}
    var interactor: ArticleDetailsPresenterToInteractorProtocol? {get set}
    var router: ArticleDetailsPresenterToRouterProtocol? {get set}
    var article: Article? { get set }
    func getArticleDetails() -> Article?
//    func startFetchingArticleDetails()
//    func showArticleDetailController(navigationController: UINavigationController)
//    func getTotalArticleCount() -> Int?
//    func getCurrentArticleCount() -> Int?
//    func getArticle(at index: Int) -> Article
}

protocol ArticleDetailsPresenterToViewProtocol: class {
//    func showArticleList(imageData: Data, title: String, explanation: String)
//    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
//    func showError()
}

protocol ArticleDetailsPresenterToRouterProtocol: class {
    static func createModule(forArticle article: Article) -> ArticleDetailTableViewController
}

protocol ArticleDetailsPresenterToInteractorProtocol: class {
    var presenter: ArticleDetailsInteractorToPresenterProtocol? {get set}
//    var databaseManager: DatabaseManagerProtocol? {get set}
//    var fileManager: FileManagerProtocol? {get set}
//    func fetchArticleDetails()
//    func totalArticleCount() -> Int?
//    func getCurrentArticleCount() -> Int?
//    func article(at index: Int) -> Article
}

protocol ArticleDetailsInteractorToPresenterProtocol: class {
    
//    func imageFetchedSuccess(imageData: Data, title: String, explanation: String)
//    func imageFetchFailed()
//    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    
}

//protocol DatabaseManagerProtocol: class {
//
//    // typeAlias: Date, title, Explanation, Image file path
//    func fetch() -> (Date?, String?, String?, String?)
//    func save(date: Date, explanation: String, filePath: String, title: String)
//    func update()
//}
//
//protocol FileManagerProtocol: class {
//    func save(fileName: String, file: Data)
//    func openFile(fileName: String) -> Data?
//}

