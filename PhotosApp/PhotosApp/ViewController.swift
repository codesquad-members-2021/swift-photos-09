//
//  ViewController.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/22.
//

import UIKit
import Photos

class ViewController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView!
    var allPhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ColorCell.nib(), forCellWithReuseIdentifier: ColorCell().identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        allPhotos = PHAsset.fetchAssets(with: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = allPhotos.object(at: indexPath.item)
        let option = PHImageRequestOptions()
   
        option.resizeMode = .exact
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.identifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: option) { image, _ in
            
            if cell.identifier == asset.localIdentifier {

                cell.imageView.image = image
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100.0, height: 100.0)
        return size
    }
}

