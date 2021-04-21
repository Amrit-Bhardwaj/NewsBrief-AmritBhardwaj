//
//  TextTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

final class TextTableViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var detailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(withText text: String) {
        detailTextView.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
