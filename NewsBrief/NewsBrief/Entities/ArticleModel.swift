//
//  ArticleModel.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation
/*
 'ArticleModel' represents the mapping model for Article response Data
 */
struct ArticleModel {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var imageData: Data?
    
    // TODO: - Json keys to be put in separate constant file
    // This can be implemented using decodable Protocol Too
    init(jsonData: [String: AnyObject]?) {
        
        if let json = jsonData {
            author = json[JSONKeys.author] as? String
            title = json[JSONKeys.title] as? String
            description = json[JSONKeys.description] as? String
            url = json[JSONKeys.url] as? String
            urlToImage = json[JSONKeys.urlToImage] as? String
            publishedAt = json[JSONKeys.publishedAt] as? String
            content = json[JSONKeys.content] as? String
        }
    }
}
