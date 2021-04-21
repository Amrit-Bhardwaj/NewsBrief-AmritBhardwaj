//
//  DetailsTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var authorLabel: UILabel!
    
    @IBOutlet private weak var publishedDateLabel: UILabel!
    
    @IBOutlet private weak var likesCountLabel: UILabel!
    
    @IBOutlet private weak var commentsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(author: String, publishedDate: String, numberOfLikes: String, numberOfComments: String) {
        authorLabel.text = "By " + author
        publishedDateLabel.text = publishedDate
        likesCountLabel.text = "Likes: " + numberOfLikes
        commentsCountLabel.text = "Comments: " + numberOfComments
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
