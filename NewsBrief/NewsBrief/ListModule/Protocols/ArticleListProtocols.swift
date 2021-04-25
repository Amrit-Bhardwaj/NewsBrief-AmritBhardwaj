//
//  ArticleListProtocols.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

// This file consists of all the protocols used throughout the Article List Module
// Passing simple Data Types(structs) for communication between layers to avoid dependency

/// This Protocol contains the APIs to communicate from VIEW --> PRESENTER
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

/// This Protocol contains the APIs to communicate from PRESENTER --> VIEW
protocol ArticleListPresenterToViewProtocol: class {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func showError(withError error: ErrorMessages)
}

/// This Protocol contains the APIs to communicate from PRESENTER --> ROUTER
protocol ArticleListPresenterToRouterProtocol: class {
    
    func presentArticleDetailScreen(fromView view: ArticleListPresenterToViewProtocol, forArticle article: Article)
    static func createModule()-> ArticleListTableViewController
}

/// This Protocol contains the APIs to communicate from PRESENTER --> INTERACTOR
protocol ArticleListPresenterToInteractorProtocol: class {
    
    var presenter: ArticleListInteractorToPresenterProtocol? {get set}
    var databaseManager: DatabaseManagerProtocol? {get set}
    var fileManager: FileManagerProtocol? {get set}
    func fetchArticleDetails()
    func totalArticleCount() -> Int?
    func getCurrentArticleCount() -> Int?
    func article(at index: Int) -> Article
}

/// This Protocol contains the APIs to communicate from INTERACTOR --> PRESENTER
protocol ArticleListInteractorToPresenterProtocol: class {
    
    func onFetchFailed(withError error: ErrorMessages)
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

/// This Protocol contains the APIs to communicate with the dB
protocol DatabaseManagerProtocol: class {
    
    func fetch() -> (Date?, String?, String?, String?)
    func save(date: Date, explanation: String, filePath: String, title: String)
    func update()
}

/// This Protocol contains the APIs to communicate with Filesystem
protocol FileManagerProtocol: class {
    
    func save(fileName: String, file: Data)
    func openFile(fileName: String) -> Data?
}
