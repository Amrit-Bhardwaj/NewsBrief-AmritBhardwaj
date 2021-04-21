//
//  GetArticleDetailsTask.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/*
 This class denotes the GET task for the Attachment(Image) details
 */
final class GetArticleDetailsTask: Task {
    
    //TODO: - This should be read from keychain
    var apiKey: String
    
    var country: String
    var category: String
    var pageSize: String
    var page: String
    
    init(apiKey: String, country: String, category: String,
         pageSize: String, page: String) {
        self.apiKey = apiKey
        self.country = country
        self.category = category
        self.pageSize = pageSize
        self.page = page
    }
    
    var request: Request {
        return UserRequests.articleDetails(country: country, category: category,
                                           apiKey: apiKey, pageSize: pageSize, page: page)
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


