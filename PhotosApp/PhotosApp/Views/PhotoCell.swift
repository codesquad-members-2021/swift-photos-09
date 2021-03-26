//
//  ColorCell.swift
//  PhotosApp
//
//  Created by Song on 2021/03/22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var livePhotoBadgeImageView: UIImageView!
    
    var identifier = "PhotoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }

    static func nib() -> UINib {
        return UINib(nibName: PhotoCell().identifier, bundle: nil)
    }
}
