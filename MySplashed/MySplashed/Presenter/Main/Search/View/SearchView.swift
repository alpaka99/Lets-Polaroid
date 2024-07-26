//
//  SearchPhotoView.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

import SnapKit

final class SearchView: BaseView {
    enum Section: CaseIterable {
        case main
    }
    
    private(set) var searchBar = UISearchBar()
    
    private let emptyView = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var collectionView = { [weak self] in
        guard let view = self else { return UICollectionView(frame: .zero)}
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: view.createLayout()
        )
        collectionView.alpha = 0
        return collectionView
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section,UnsplashImageData>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDataSource()
        updateSnapShot([])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(searchBar)
        self.addSubview(emptyView)
        self.addSubview(collectionView)
    }
    
    
    override func configureLayout() {
        super.configureLayout()
        
        searchBar.snp.makeConstraints { search in
            search.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        emptyView.snp.makeConstraints { label in
            label.center.equalTo(self.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(searchBar.snp.bottom)
            collectionView.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        setEmptyState()
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PictureViewCell, UnsplashImageData> { cell, indexPath, itemIdentifier in
            cell.configureUI(.search)
            cell.setImage(UIImage(systemName: "star.fill")!)
            cell.setTotalLike(itemIdentifier.unsplashResponse.likes)
            cell.backgroundView?.backgroundColor = MSColor.blue.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UnsplashImageData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.setImage(itemIdentifier.image)
            return cell
        })
    }
    
    func updateSnapShot(_ data: [UnsplashImageData]) {
        if data.isEmpty {
            setEmptyState()
        } else {
            var snapShot = dataSource.snapshot(for: .main)
            snapShot.deleteAll()
            snapShot.append(data)
            
            dataSource.apply(snapShot, to: .main)
            setSearchedState()
        }
    }
    
    func setEmptyState() {
        emptyView.alpha = 1
        collectionView.alpha = 0
    }
    
    func setSearchedState() {
        emptyView.alpha = 0
        collectionView.alpha = 1
    }
}
