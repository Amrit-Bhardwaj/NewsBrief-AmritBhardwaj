//
//  TitleSubTitleTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'TitleSubTitleTableViewCell' implements and configurs the Title Description section of Article
 */
final class TitleSubTitleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    /// This function is used to configure the 'TitleSubTitleTableViewCell' cell
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - subTitle: Sub title
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
