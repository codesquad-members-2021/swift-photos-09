//
//  ColorCell.swift
//  PhotosApp
//
//  Created by Song on 2021/03/22.
//

import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "ColorCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.random
    }

    static func nib() -> UINib {
        return UINib(nibName: ColorCell.identifier, bundle: nil)
    }
}
