//
//  ArticleDetailsPresenter.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/// This enum defines the number of sections in the Article Detail View
enum ArticleSections: Int, CaseIterable {
    case articleDetail
}

/// This enum defines the number of rows for Article Detail View
enum ArticleRows: Int, CaseIterable {
    case titleDescription
    case articleImage
    case articleMeta
    case articleContent
}

/*
 'ArticleDetailsPresenter' class handles data flow to and from Article Details View
 */
final class ArticleDetailsPresenter: ArticleDetailsViewToPresenterProtocol {
    
    /// View Instance
    var view: ArticleDetailsPresenterToViewProtocol?
    
    /// Interactor Instance
    var interactor: ArticleDetailsPresenterToInteractorProtocol?
    
    /// Router Instance
    var router: ArticleDetailsPresenterToRouterProtocol?
    
    /// Article Data used to display Article Detail View
    var article: Article?
    
    /// This function returns the article Data for the Article Detail View
    ///
    /// - Returns: Article
    func getArticleDetails() -> Article? {
        return article
    }
    
    /// This function is used to get Article Meta(Likes, Comments) details
    ///
    /// - Parameters:
    ///   - id: Article ID
    func getArticleMetaDetails(forArticleId id: String?) {
        interactor?.fetchArticleMetaDetails(forArticleID: id)
    }
    
    /// This function returns the number of sections on the view
    func numberOfSections() -> Int {
        return ArticleSections.allCases.count
    }
    
    /// This function returns the number of rows in
    func numberOfRowsInSection(section: Int) -> Int {
        return ArticleRows.allCases.count
    }
}

extension ArticleDetailsPresenter: ArticleDetailsInteractorToPresenterProtocol {
    
    /// This function is used to send meta Details(Likes, comments) to the view
    ///
    /// - Parameters:
    ///   - metaData: Article Meta Data
    func metaFetchSuccess(withMetaData metaData: ArticleMeta) {
        view?.metaDetails(withMetaData: metaData)
    }
    
    /// This function is used to send error messages to view
    ///
    /// - Parameters:
    ///   - error: Error Message
    func metaFetchFailed(withError error: ErrorMessages) {
        view?.showMetaError(withError: error)
    }
}

