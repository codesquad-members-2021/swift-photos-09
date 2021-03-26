//
//  DoodleViewCell.swift
//  PhotosApp
//
//  Created by Song on 2021/03/25.
//

import UIKit

class DoodleViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
