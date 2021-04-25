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
    
    /// Article number of likes
    private var likesCount: String?
    
    /// Article number of comments
    private var commentsCount: String?
    
    /// This function is used to perform fetching of Meta(Likes+Comments) for an article ID
    ///
    /// - Parameters:
    ///   - articleID: Article ID
    private func performFetch(withArticleID articleID: String?) {
        
        guard let articleID = articleID else {return}
        
        /// List of Article Meta to fetch
        let metaArray = [ArticleMetaPath.likes, ArticleMetaPath.comments]
        
        /// Dispatch group used to perform concurrent fetch
        let group = DispatchGroup()
        
        for meta in metaArray {
            
            /// Entering the group
            group.enter()
            
            /// Mata path
            let path = meta.rawValue + StringConstants.forwardSlash + articleID
            
            /// Article Meta Task
            let articleMetaTask = GetArticleMetaTask(path: path)
            
            /// Network Dispatcher Instance
            let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.openUrl))
            
            /// Executing the Article meta task
            articleMetaTask.execute(in: dispatcher) { [weak self] (json) in
                
                switch meta {
                
                case .comments:
                    
                    if let json = json as? [String: AnyObject],
                       let comments = json[JSONKeys.comments] as? Int {
                        self?.commentsCount = String(comments)
                    }
                    
                case .likes:
                    
                    if let json = json as? [String: AnyObject],
                       let likes = json[JSONKeys.likes] as? Int {
                        self?.likesCount = String(likes)
                    }
                }
                
                /// Leaving the group on success
                group.leave()
                
            } failure: { (error) in
                
                /// Leaving the group on failure
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            /// Notify the presenter after Meta is successfully fetched
            let articleMeta = ArticleMeta(likes: self.likesCount, comments: self.commentsCount)
            self.presenter?.metaFetchSuccess(withMetaData: articleMeta)
        }
    }
}

extension ArticleDetailsIntereactor: ArticleDetailsPresenterToInteractorProtocol {
    
    /// This function is used to fetch article Meta Details for a given article ID
    ///
    /// - Parameters:
    ///   - forArticleID: Article ID
    func fetchArticleMetaDetails(forArticleID id: String?) {
        if NetworkReachabilityManager.shared.connectedToNetwork() {
            performFetch(withArticleID: id)
        } else {
            presenter?.metaFetchFailed(withError: ErrorMessages.noInternet)
        }
    }
}
