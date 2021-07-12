//
//  DetailBackdropView.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit

class DetailBackdropView: UICollectionReusableView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    
    private let focusGuide = UIFocusGuide()
    
    typealias ButtonTapClosure = (() -> Void)
    public var onPlay: ButtonTapClosure?
    public var onWishlist: ButtonTapClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        self.addLayoutGuide(focusGuide)
        focusGuide.leadingAnchor.constraint(equalTo: wishlistButton.trailingAnchor).isActive = true
        focusGuide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalTo: wishlistButton.heightAnchor).isActive = true
        focusGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        focusGuide.preferredFocusEnvironments = [playButton]
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        onPlay?()
    }
    
    @IBAction func wishlistButtonTapped(_ sender: Any) {
        onWishlist?()
    }
}
