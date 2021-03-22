//
//  ViewController.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ColorCell.nib(), forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        
        return cell
    }
}

