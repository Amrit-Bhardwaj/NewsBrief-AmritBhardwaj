//
//  DetailsTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'DetailsTableViewCell' implements and configurs the Article Meta section of Article Detail View
 */
final class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    
    /// This function is used to configure 'DetailsTableViewCell' cell
    ///
    /// - Parameters:
    ///   - author: Author name
    ///   - publishedDate: Article published Date
    ///   - numberOfLikes: Article Likes count
    ///   - numberOfComments: Article comments count
    func configure(author: String, publishedDate: String,
                   numberOfLikes: String, numberOfComments: String) {
        authorLabel.text = "By " + author
        publishedDateLabel.text = publishedDate
        likesCountLabel.text = "Likes: " + numberOfLikes
        commentsCountLabel.text = "Comments: " + numberOfComments
    }
}
