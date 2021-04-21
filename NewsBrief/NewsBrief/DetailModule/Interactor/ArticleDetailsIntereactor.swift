//
//  ArticleDetailsIntereactor.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import Foundation

final class ArticleDetailsIntereactor {
    
    var presenter: ArticleDetailsInteractorToPresenterProtocol?
    private var likesCount: String?
    private var commentsCount: String?
    
    // TODO: - Fetch the Number of likes and comments for the article
    private func performFetch(withArticleID articleID: String?) {
        
        guard let articleID = articleID else {return}
        
        let metaArray = [ArticleMetaPath.likes, ArticleMetaPath.comments]
        let group = DispatchGroup()
        
        for meta in metaArray {
            group.enter()
            let path = meta.rawValue + "/" + articleID
            
            let articleMetaTask = GetArticleMetaTask(path: path)
            
            
            let dispatcher = NetworkDispatcher(environment: Environment(Env.debug.rawValue, host: AppConstants.openUrl))
            
            articleMetaTask.execute(in: dispatcher) { [weak self] (json) in
                
                switch meta {
                case .comments:
                    if let comments = (json as? [String: AnyObject])!["comments"] as? Int {
                        self?.commentsCount = String(comments)
                    }
                case .likes:
                    if let likes = (json as? [String: AnyObject])!["likes"] as? Int {
                        self?.likesCount = String(likes)
                    }
                }
                group.leave()
                
            } failure: { (error) in
                // error
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let articleMeta = ArticleMeta(likes: self.likesCount, comments: self.commentsCount)
            self.presenter?.metaFetchSuccess(withMetaData: articleMeta)
        }
    }
}

extension ArticleDetailsIntereactor: ArticleDetailsPresenterToInteractorProtocol {
    
    func fetchArticleMetaDetails(forArticleID id: String?) {
        performFetch(withArticleID: id)
    }
}
