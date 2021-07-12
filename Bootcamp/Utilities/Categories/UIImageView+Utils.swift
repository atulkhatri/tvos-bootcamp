//
//  UIImageView+Utils.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(withURL url: URL?) {
        if let url = url {
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image"), options: [], context: nil)
        }
    }
}
