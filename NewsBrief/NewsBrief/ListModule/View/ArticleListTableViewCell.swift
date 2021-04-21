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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(image: .none, description: .none, author: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
    }
    
    /// This function is used to save the data with the fileName into Application support directory
    /// - Parameters:
    ///   - image: List View Image
    ///   - description: News Description
    ///   - author: Author String
    func configure(image: UIImage?, description: String?, author: String?) {
        if image == .none && description == .none && author == .none {
            articleAuthor.alpha  =  0
            articleDescription.alpha = 0
            articleImageView.alpha = 0
            activityIndicator.startAnimating()
        } else {
            articleAuthor.text = author
            articleDescription.text = description
            articleImageView.image = image
            articleAuthor.alpha  =  1
            articleDescription.alpha = 1
            articleImageView.alpha = 1
            activityIndicator.stopAnimating()
        }
    }
}
