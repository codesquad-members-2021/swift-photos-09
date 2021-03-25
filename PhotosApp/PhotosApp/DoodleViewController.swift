//
//  DoodleViewController.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/24.
//

import UIKit

class DoodleViewController: UICollectionViewController {
    
    var savedItem: DoodleViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .darkGray
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPressed))
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.title = "Doodles"
        
        let longPressGesutreRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellDidPress))
        longPressGesutreRecognizer.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longPressGesutreRecognizer)
    }
    
    @objc
    func closeButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cellDidPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let indexPath = indexPath {
            let cell = self.collectionView.cellForItem(at: indexPath) as! DoodleViewCell
            savedItem = cell
            cell.becomeFirstResponder()
            let saveMenuItem = UIMenuItem(title: "Save", action: #selector(savePhoto))
            UIMenuController.shared.menuItems = [saveMenuItem]
            UIMenuController.shared.showMenu(from: collectionView, rect: cell.frame)
        }
    }
    
    @objc
    func savePhoto(sender: UIMenuController) {
        UIImageWriteToSavedPhotosAlbum(savedItem.imageView.image ?? UIImage(), self, #selector(image), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
}

extension DoodleViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parseJson(fileName: "doodle")?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoodleViewCell", for: indexPath) as! DoodleViewCell
        
        DispatchQueue(label: "jsonLoading", qos: .background).async {
            guard let doodle = self.parseJson(fileName: "doodle")?[indexPath.item] else { return }
            if let url = URL(string: doodle.imageName) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        let longPressGesutreRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellDidPress))
        longPressGesutreRecognizer.minimumPressDuration = 0.3
        cell.addGestureRecognizer(longPressGesutreRecognizer)
        
        return cell
    }
}

extension DoodleViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110.0, height: 50.0)
        return size
    }
}
