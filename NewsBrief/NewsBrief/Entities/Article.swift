//
//  Article.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import Foundation

/*
 'Article' is the encapsulates Article data to be shared across different layers
 */
struct Article {
    var author: String?
    var description: String?
    var image: Data?
    var title: String?
    var publishedDate: String?
    var content: String?
    var articleID: String?
}

