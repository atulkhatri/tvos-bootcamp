//
//  DetailViewController.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit
import AVKit

private let kRailCellIdentifier = "RailCell"
private let kBackdropIdentifier = "DetailBackdropView"

class DetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var asset: AssetModel!
    var rail: RailModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: kRailCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kRailCellIdentifier)
        collectionView.register(UINib(nibName: kBackdropIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kBackdropIdentifier)
    }
    
    private func openDetails(for asset: AssetModel, with rail: RailModel) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.rail = rail
        detailVC.asset = asset
        present(detailVC, animated: true, completion: nil)
    }
    
    private func openPlayer(with asset: AssetModel) {
        let playerVC = PlayerViewController()
        playerVC.asset = asset
        playerVC.rail = rail
        present(playerVC, animated: true, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: kRailCellIdentifier, for: indexPath) as? RailCell
        guard let cell = collectionCell else {
            return UICollectionViewCell()
        }
        cell.loadData(rail: rail)
        cell.onSelect = { [unowned self] rail, asset in
            self.openDetails(for: asset, with: rail)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kBackdropIdentifier, for: indexPath) as? DetailBackdropView
        header?.imageView.setImage(withURL: asset.backdrop.toUrl)
        header?.titleLabel.text = asset.title
        header?.summaryLabel.text = asset.summary
        header?.onPlay = { [unowned self] in
            self.openPlayer(with: asset)
        }
        header?.onWishlist = {
            print("Wishlist tapped")
        }
        return header ?? UICollectionReusableView()
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch asset.type {
        case .movie: return CGSize(width: collectionView.frame.size.width, height: Constants.moviesCellHeight)
        case .series: return CGSize(width: collectionView.frame.size.width, height: Constants.seriesCellHeight)
        }
    }
}
