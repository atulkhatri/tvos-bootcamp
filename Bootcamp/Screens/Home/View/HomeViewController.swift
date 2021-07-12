//
//  HomeViewController.swift
//  Bootcamp
//
//  Created by Atul Khatri on 22/02/21.
//

import UIKit

private let kRailCellIdentifier = "RailCell"
private let kRailHeaderIdentifier = "RailHeaderView"

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var pageModel: PageModel?
    public var type: HomeScreenType = .movies
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func fetchData() {
        switch type {
        case .movies:
            NetworkManager().fetchMovieData { [weak self] (page, error) in
                guard let self = self else { return }
                if let page = page {
                    self.loadData(page: page)
                } else {
                    print("No movies found!!")
                }
            }
        case .series:
            NetworkManager().fetchSeriesData { [weak self] (page, error) in
                guard let self = self else { return }
                if let page = page {
                    self.loadData(page: page)
                } else {
                    print("No series found!!")
                }
            }
        }
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: kRailCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kRailCellIdentifier)
        collectionView.register(UINib(nibName: kRailHeaderIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kRailHeaderIdentifier)
    }
    
    private func loadData(page: PageModel) {
        pageModel = page
        collectionView.reloadData()
    }
    
    private func openDetails(for asset: AssetModel, with rail: RailModel) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.rail = rail
        detailVC.asset = asset
        present(detailVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pageModel?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: kRailCellIdentifier, for: indexPath) as? RailCell
        guard let rail = pageModel?.data[indexPath.section], let cell = collectionCell else {
            return UICollectionViewCell()
        }
        cell.loadData(rail: rail)
        cell.onSelect = { [unowned self] rail, asset in
            self.openDetails(for: asset, with: rail)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kRailHeaderIdentifier, for: indexPath) as? RailHeaderView
        if let rail = pageModel?.data[indexPath.section] {
            header?.titleLabel.text = rail.title
        }
        return header ?? UICollectionReusableView()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .movies: return CGSize(width: collectionView.frame.size.width, height: Constants.moviesCellHeight)
        case .series: return CGSize(width: collectionView.frame.size.width, height: Constants.seriesCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Constants.sectionHeaderHeight)
    }
}

enum HomeScreenType {
    case movies
    case series
}
