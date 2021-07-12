//
//  AssetCell.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit
import TVUIKit

private let kPostViewTag = 1100

class AssetCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        if let view = contentView.viewWithTag(kPostViewTag) {
            view.removeFromSuperview()
        }
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    public func loadData(asset: AssetModel) {
        let posterView = TVPosterView()
        posterView.tag = kPostViewTag
        let image = (asset.type == .movie) ? asset.image : asset.backdrop
        posterView.imageView.setImage(withURL: image.toUrl)
        posterView.title = asset.title
        contentView.addSubview(posterView)
        posterView.alignToSuperView()
    }
}
