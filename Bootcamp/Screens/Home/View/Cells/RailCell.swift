//
//  RailCell.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/03/21.
//

import UIKit
import SDWebImage

private let kAssetCellIdentifier = "AssetCell"

class RailCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private var rail: RailModel!
    typealias CellSelectionClosure = ((RailModel, AssetModel) -> Void)
    public var onSelect: CellSelectionClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: kAssetCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kAssetCellIdentifier)
    }
    
    public func loadData(rail: RailModel) {
        self.rail = rail
        collectionView.reloadData()
    }
    
    override var canBecomeFocused: Bool {
        return false
    }
}

extension RailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rail.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: kAssetCellIdentifier, for: indexPath) as? AssetCell
        guard let asset = rail?.list[indexPath.item], let cell = collectionCell else {
            return UICollectionViewCell()
        }
        cell.loadData(asset: asset)
        return cell
    }
}

extension RailCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(rail, rail.list[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension RailCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let asset = rail?.list[indexPath.item] {
            switch asset.type {
            case .movie: return CGSize(width: Constants.moviesCellWidth, height: Constants.moviesCellHeight)
            case .series: return CGSize(width: Constants.seriesCellWidth, height: Constants.seriesCellHeight)
            }
        }
        return .zero
    }
}

