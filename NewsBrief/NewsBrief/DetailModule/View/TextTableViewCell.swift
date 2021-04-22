//
//  TextTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'TextTableViewCell' implements and configurs the Article content section of Article Detail View
 */
final class TextTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var detailTextView: UITextView!
    
    /// This function is used to configure 'TextTableViewCell' cell
    ///
    /// - Parameters:
    ///   - text: Aritcle content
    func configure(withText text: String) {
        detailTextView.text = text
    }
}
