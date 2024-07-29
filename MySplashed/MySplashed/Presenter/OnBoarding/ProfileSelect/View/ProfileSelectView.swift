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
    lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createLayout(rows: 4, columns: 4, spacing: 10, groupDirection: .horizontal, scrollDirection: .vertical))
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ProfileImageData>!
    
    enum Section {
        case main
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureDataSource()
        updateSnapShot(with: [])
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
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProfileSelectCell, ProfileImageData> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProfileImageData>(
            collectionView: profileCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.image.image.image = UIImage(named: itemIdentifier.imageName) ?? UIImage(systemName: "star")
                if itemIdentifier.isSelected {
                    cell.selected()
                } else {
                    cell.deselected()
                }
                return cell
            })
    }
    
    func updateSnapShot(with items: [ProfileImageData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ProfileImageData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapShot)
    }
}

