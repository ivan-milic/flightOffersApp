//
//  Extensions.swift
//  KiwiApp
//
//  Created by Ivan Milic on 18.5.21..
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(url: URL) {
        
        if let image = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1]
        
        layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
    }
}
