//
//  ProfileSelectView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class ProfileSelectView: BaseView {
    let selectedProfileImage = {
        let imageView = RoundImageView()
        imageView.image.image = UIImage(named: ProfileImage.profile0.rawValue)
        imageView.selected()
        imageView.showBadge()
        return imageView
    }()
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createLayout(absoluteRowHeight: 80, columns: 4, spacing: 10, direction: .horizontal))
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ProfileImage>!
    
    enum Section {
        case main
    }
    
    var items = ProfileImage.allCases
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureDataSource()
        updateSnapShot()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        self.addSubview(selectedProfileImage)
        self.addSubview(profileCollectionView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        selectedProfileImage.snp.makeConstraints { image in
            image.top.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
            image.width.equalTo(self.snp.width)
                .multipliedBy(0.3)
            image.height.equalTo(selectedProfileImage.snp.width)
            image.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        profileCollectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(selectedProfileImage.snp.bottom)
                .offset(16)
            collectionView.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            collectionView.height.equalTo(profileCollectionView.snp.width)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        profileCollectionView.isScrollEnabled = false
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(85))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileSelectCell, ProfileImage> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProfileImage>(
            collectionView: profileCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.image.image.image = UIImage(named: itemIdentifier.rawValue) ?? UIImage(systemName: "star")
                return cell
            })
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ProfileImage>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapShot)
    }
}
