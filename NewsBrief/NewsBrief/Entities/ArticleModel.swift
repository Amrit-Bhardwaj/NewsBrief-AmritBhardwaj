//
//  ArticleModel.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

struct ArticleModel {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    // TODO: - Json keys to be put in separate constant file
    init(jsonData: [String: AnyObject]?) {
        
        if let json = jsonData {
            
            author = json["author"] as? String
            title = json["title"] as? String
            description = json["description"] as? String
            url = json["url"] as? String
            urlToImage = json["urlToImage"] as? String
            publishedAt = json["publishedAt"] as? String
            content = json["content"] as? String
        }
    }
}
