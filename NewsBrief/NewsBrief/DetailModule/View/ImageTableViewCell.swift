//
//  ImageTableViewCell.swift
//  NewsBrief
//
//  Created by Amrit Bhardwaj on 21/04/21.
//

import UIKit

/*
 'ImageTableViewCell' implements and configurs the Image section of Article
 */
final class ImageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var detailImageView: UIImageView!
    
    /// This function is used to configure 'ImageTableViewCell' cell
    ///
    /// - Parameters:
    ///   - image: Article Image
    func configure(image: UIImage?) {
        detailImageView.image = image
    }
}
