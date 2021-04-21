//
//  GetArticleMetaTask.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import Foundation

class GetArticleMetaTask: Task {
    
    var path: String
    
    init(path: String) {
        self.path = path
    }
    
    var request: Request {
        return UserRequests.articleMeta(path: path)
    }
    
    func execute(in dispatcher: Dispatcher, success: @escaping ((Any) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        do {
            try dispatcher.execute(request: self.request, success: { (response) in
                
                switch response {
                
                case .json(let json):
                    success(json)
                case .error(_, let errorMessage):
                    failure(errorMessage)
                    
                default:
                    failure(nil)
                }
                
            }, failure: { (error) in
                NSLog("Error while trying to fetch image details")
                failure(error)
            })
        } catch {
            NSLog("Error")
        }
    }
}
