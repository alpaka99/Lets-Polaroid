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
        imageView.image.image = UIImage(named: "profile_0")
        imageView.selected()
        imageView.showBadge()
        return imageView
    }()
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<String, String>!
    var items = [
        "profile_0",
        "profile_1",
        "profile_2",
        "profile_3",
        "profile_4",
        "profile_5",
        "profile_6",
        "profile_7",
        "profile_8",
        "profile_9",
        "profile_10",
        "profile_11",
    ]
    
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
        let cellRegistration = UICollectionView.CellRegistration<ProfileSelectCell, String> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, String>(
            collectionView: profileCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.image.image.image = UIImage(named: itemIdentifier) ?? UIImage(systemName: "star")
                return cell
            })
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<String, String>()
        snapShot.appendSections(["asd"])
        snapShot.appendItems(items, toSection: "asd")
        
        dataSource.apply(snapShot)
    }
}
