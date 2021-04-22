//
//  ArticleDetailsProtocols.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import Foundation

/// This file consists of all the protocols used throughout the Article Details Module
/// Passing simple native data type as params for communication between layers to avoid dependency

/// This Protocol contains the APIs to communicate from VIEW --> PRESENTER
protocol ArticleDetailsViewToPresenterProtocol: class {
    
    var view: ArticleDetailsPresenterToViewProtocol? {get set}
    var interactor: ArticleDetailsPresenterToInteractorProtocol? {get set}
    var router: ArticleDetailsPresenterToRouterProtocol? {get set}
    var article: Article? { get set }
    func getArticleDetails() -> Article?
    func getArticleMetaDetails(forArticleId id: String?)
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
}

/// This Protocol contains the APIs to communicate from PRESENTER --> VIEW
protocol ArticleDetailsPresenterToViewProtocol: class {
    
    func metaDetails(withMetaData metaData: ArticleMeta)
}

/// This Protocol contains the APIs to communicate from PRESENTER --> ROUTER
protocol ArticleDetailsPresenterToRouterProtocol: class {
    
    static func createModule(forArticle article: Article) -> ArticleDetailTableViewController
}

/// This Protocol contains the APIs to communicate from PRESENTER --> INTERACTOR
protocol ArticleDetailsPresenterToInteractorProtocol: class {
    
    var presenter: ArticleDetailsInteractorToPresenterProtocol? {get set}
    func fetchArticleMetaDetails(forArticleID id: String?)
}

/// This Protocol contains the APIs to communicate from INTERACTOR --> PRESENTER
protocol ArticleDetailsInteractorToPresenterProtocol: class {
    
    func metaFetchSuccess(withMetaData metaData: ArticleMeta)
}
