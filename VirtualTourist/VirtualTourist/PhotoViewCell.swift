//
//  PhotoViewCell.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // MARK: - View Background, Start Spinner
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    
    // MARK: - Replace Background With Photo, Stop Spinner
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
}
