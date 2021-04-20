//
//  ArticleListTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 20/04/21.
//

import UIKit

final class ArticleListTableViewCell: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleDescription: UILabel!
    @IBOutlet private weak var articleAuthor: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(image: UIImage?, description: String, author: String) {
        articleAuthor.text = author
        articleDescription.text = description
        articleImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
