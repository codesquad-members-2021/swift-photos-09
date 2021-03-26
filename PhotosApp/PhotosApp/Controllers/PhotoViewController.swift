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
    let videoManager = VideoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCell.nib(), forCellWithReuseIdentifier: PhotoCell().identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        allPhotos = PHAsset.fetchAssets(with: nil)
        
        PHPhotoLibrary.shared().register(self)
        
        collectionView.allowsMultipleSelection = true
        updateDoneButtonState()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        videoManager.build(outputSize: CGSize(width: 100.0, height: 100.0), collectionView: collectionView)
    }
    
    @IBAction func didTapAddPhotoButton(_ sender: Any) {
        guard let doodleViewController = self.storyboard?.instantiateViewController(withIdentifier: "DoodleViewController") else {
            return
        }
        self.navigationController?.pushViewController(doodleViewController, animated: true)
    }
    
    func updateDoneButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = collectionView.indexPathsForSelectedItems!.count >= 3
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateDoneButtonState()
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
