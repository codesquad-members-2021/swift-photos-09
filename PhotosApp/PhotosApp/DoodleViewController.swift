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
        self.navigationItem.title = "Doodles"
    }
    
    @objc
    func closeButtonPressed() {
        self.navigationController?.popViewController(animated: true)
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
        
        return cell
    }
}

extension DoodleViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110.0, height: 50.0)
        return size
    }
}
