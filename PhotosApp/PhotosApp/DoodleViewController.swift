//
//  DoodleViewController.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/24.
//

import UIKit

class DoodleViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .darkGray
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPressed))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc
    func closeButtonPressed() {
        
    }
}
