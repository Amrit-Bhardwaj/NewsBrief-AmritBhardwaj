//
//  ArticleDetailRemoteDataManager.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 27/04/21.
//

import Foundation

/// This class performs the Network call to fetch Article Details Meta Data
class ArticleDetailRemoteDataManager: ArticleDetailsRemoteInputProtocol {
    
    var remoteRequestHandler: ArticleDetailsRemoteOutputProtocol?
    
    /// Article number of likes
    private var likesCount: String?
    
    /// Article number of comments
    private var commentsCount: String?
    
    
    func retrieveArticleMeta(forArticleId id: String?) {
        if NetworkReachabilityManager.shared.connectedToNetwork() {
            performFetch(withArticleID: id)
        } else {
            remoteRequestHandler?.onError(withError: ErrorMessages.noInternet)
        }
    }
    
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
            
            self.remoteRequestHandler?.onArticleMetaRetrieved(likesCount: self.likesCount, commentCount: self.commentsCount)
        }
    }
}
