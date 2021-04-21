//
//  ArticleListProtocols.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

// This file consists of all the protocols used throughout the Article List Module
// Passing simple native data type as params for communication between layers to avoid dependency
protocol ArticleListViewToPresenterProtocol: class {
    
    var view: ArticleListPresenterToViewProtocol? {get set}
    var interactor: ArticleListPresenterToInteractorProtocol? {get set}
    var router: ArticleListPresenterToRouterProtocol? {get set}
    func startFetchingArticleDetails()
    func showArticleDetail(forArticle article: Article)
    func getTotalArticleCount() -> Int?
    func getCurrentArticleCount() -> Int?
    func getArticle(at index: Int) -> Article
}

protocol ArticleListPresenterToViewProtocol: class{
    func showArticleList(imageData: Data, title: String, explanation: String)
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func showError()
}

protocol ArticleListPresenterToRouterProtocol: class {
    func presentArticleDetailScreen(fromView view: ArticleListPresenterToViewProtocol, forArticle article: Article)
    static func createModule()-> ArticleListTableViewController
}

protocol ArticleListPresenterToInteractorProtocol: class {
    var presenter: ArticleListInteractorToPresenterProtocol? {get set}
    var databaseManager: DatabaseManagerProtocol? {get set}
    var fileManager: FileManagerProtocol? {get set}
    func fetchArticleDetails()
    func totalArticleCount() -> Int?
    func getCurrentArticleCount() -> Int?
    func article(at index: Int) -> Article
}

protocol ArticleListInteractorToPresenterProtocol: class {
    
    func imageFetchedSuccess(imageData: Data, title: String, explanation: String)
    func imageFetchFailed()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

protocol DatabaseManagerProtocol: class {
    
    // typeAlias: Date, title, Explanation, Image file path
    func fetch() -> (Date?, String?, String?, String?)
    func save(date: Date, explanation: String, filePath: String, title: String)
    func update()
}

protocol FileManagerProtocol: class {
    func save(fileName: String, file: Data)
    func openFile(fileName: String) -> Data?
}
