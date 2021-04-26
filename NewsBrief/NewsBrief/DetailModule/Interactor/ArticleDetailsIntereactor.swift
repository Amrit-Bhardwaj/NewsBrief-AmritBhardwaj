//
//  ArticleDetailsIntereactor.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import Foundation

/*
 'ArticleDetailsIntereactor' handles the business logic for Article Details View
 */
final class ArticleDetailsIntereactor {
    
    /// Article Details Presenter Instance
    var presenter: ArticleDetailsInteractorToPresenterProtocol?
    
    /// Remote Data manager instance
    var remoteDataManager: ArticleDetailsRemoteInputProtocol?
}

extension ArticleDetailsIntereactor: ArticleDetailsPresenterToInteractorProtocol {
    
    /// This function is used to fetch article Meta Details for a given article ID
    ///
    /// - Parameters:
    ///   - forArticleID: Article ID
    func fetchArticleMetaDetails(forArticleID id: String?) {
        remoteDataManager?.retrieveArticleMeta(forArticleId: id)
    }
}

extension ArticleDetailsIntereactor: ArticleDetailsRemoteOutputProtocol {
    
    func onArticleMetaRetrieved(likesCount likes: String?, commentCount comment: String?) {
        let articleMeta = ArticleMeta(likes: likes, comments: comment)
        presenter?.metaFetchSuccess(withMetaData: articleMeta)
    }
    
    func onError(withError error: ErrorMessages) {
        presenter?.metaFetchFailed(withError: error)
    }
}
