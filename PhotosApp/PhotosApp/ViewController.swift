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
        
        PHPhotoLibrary.shared().register(self)
        parseJson(fileName: "doodle")
    }
    
    func parseJson(fileName: String) -> [DoodleModel]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([DoodleData].self, from: data)
                let imageNames = jsonData.map { $0.image }
                let doodles = imageNames.map { DoodleModel(imageName: $0)}
    
                return doodles
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return allPhotos.count
//        return parseJson(fileName: "doodle")?.count ?? 0
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let asset = allPhotos.object(at: indexPath.item)
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
//        cell.identifier = asset.localIdentifier
//        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: .none) { image, _ in
//
//            if cell.identifier == asset.localIdentifier {
//
//                cell.imageView.image = image
//            }
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
//        if let doodles = parseJson(fileName: "doodle") {
//
//
//            let urls = doodles.map {
//                URL(string: $0.imageName)
//            }
//            do {
//                let datas = try urls.map {
//
//                    try Data(contentsOf: $0!)
//                }
//                cell.imageView.image = UIImage(data: datas[indexPath.row])
//            } catch {
//                print(error)
//            }
//        }
//
//        print(indexPath.row)

        let test = parseJson(fileName: "doodle")![0].imageName
        let url = URL(string: test)
        let data = try? Data(contentsOf: url!)
        cell.imageView.image = UIImage(data: data!)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100.0, height: 100.0)
        return size
    }
}

extension ViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: allPhotos) else { return }
        
        DispatchQueue.main.sync {
            allPhotos = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                if let removed = changes.removedIndexes, !removed.isEmpty {
                    print("removed")
                }
                if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                    print("inserted")
                }
                changes.enumerateMoves { fromIndex, toIndex in
                    print("moves")
                }
            }
        }
    }
}
