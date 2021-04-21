//
//  ArticleListTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

/*
 'ArticleListTableViewCell' implements and configurs the cell for news list View
 */
final class ArticleListTableViewCell: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleDescription: UILabel!
    @IBOutlet private weak var articleAuthor: UILabel!
    
    /// This function is used to save the data with the fileName into Application support directory
    /// - Parameters:
    ///   - image: List View Image
    ///   - description: News Description
    ///   - author: Author String
    func configure(image: UIImage?, description: String, author: String) {
        articleAuthor.text = author
        articleDescription.text = description
        articleImageView.image = image
    }
}
