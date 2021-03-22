//
//  UIColor+Random.swift
//  PhotosApp
//
//  Created by 오킹 on 2021/03/22.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}
