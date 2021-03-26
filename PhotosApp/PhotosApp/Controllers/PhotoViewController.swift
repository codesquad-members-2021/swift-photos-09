//
//  ViewController.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/22.
//

import UIKit
import Photos
import PhotosUI

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addPhotoButton: UIBarButtonItem!
    var allPhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    var savedItems: [PhotoCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCell.nib(), forCellWithReuseIdentifier: PhotoCell().identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        allPhotos = PHAsset.fetchAssets(with: nil)
        
        PHPhotoLibrary.shared().register(self)
        
        let longPressGesutreRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellDidPress))
        longPressGesutreRecognizer.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longPressGesutreRecognizer)
        
        collectionView.allowsMultipleSelection = true
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    @objc
    func cellDidPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let indexPath = indexPath {
            let cell = self.collectionView.cellForItem(at: indexPath) as! PhotoCell
            savedItems.append(cell)
            cell.becomeFirstResponder()
            //let saveMenuItem = UIMenuItem(title: "Save", action: #selector(savePhoto))
            //UIMenuController.shared.menuItems = [saveMenuItem]
            //UIMenuController.shared.showMenu(from: collectionView, rect: cell.frame)
        }
    }
    
    @IBAction func didTapAddPhotoButton(_ sender: Any) {
        guard let doodleViewController = self.storyboard?.instantiateViewController(withIdentifier: "DoodleViewController") else {
            return
        }
        self.navigationController?.pushViewController(doodleViewController, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = allPhotos.object(at: indexPath.item)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell().identifier, for: indexPath) as! PhotoCell
        
        if asset.mediaSubtypes.contains(.photoLive) {
            cell.livePhotoBadgeImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        }
        
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = cellBackgroundView
        
        cell.identifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: .none) { image, _ in
            
            if cell.identifier == asset.localIdentifier {
                
                cell.imageView.image = image
            }
        }
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100.0, height: 100.0)
        return size
    }
}

extension PhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: allPhotos) else { return }
        
        DispatchQueue.main.sync {
            allPhotos = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadData()
                }
            }
        }
    }
}
