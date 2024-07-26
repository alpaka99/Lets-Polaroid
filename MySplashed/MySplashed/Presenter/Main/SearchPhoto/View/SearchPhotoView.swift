//
//  SearchPhotoView.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

import SnapKit

final class SearchPhotoView: BaseView {
    private let searchBar = UISearchBar()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<String,String>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDataSource()
        updateSnapShot()
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
        self.addSubview(collectionView)
    }
    
    
    override func configureLayout() {
        super.configureLayout()
        
        searchBar.snp.makeConstraints { search in
            search.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(searchBar.snp.bottom)
            collectionView.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PictureViewCell, String> { cell, indexPath, itemIdentifier in
            cell.setImage(UIImage(systemName: "star.fill")!)
            cell.backgroundView?.backgroundColor = MSColor.blue.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.backgroundColor = MSColor.blue.color
            return cell
        })
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<String, String>()
        
        snapShot.appendSections(["test"])
        snapShot.appendItems(
            [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",],
            toSection: "test"
        )
        
        dataSource.apply(snapShot)
    }
}
