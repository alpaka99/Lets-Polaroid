//
//  MBTIView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class MBTIView: BaseView {
    let title = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let mbtiCollectionView  = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.createLayout(rows: 2, columns: 4, spacing: 8, direction: .horizontal))
    
    var dataSource: UICollectionViewDiffableDataSource<String, String>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDataSource()
        updateSnapShot()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(title)
        self.addSubview(mbtiCollectionView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        mbtiCollectionView.isScrollEnabled = false
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        title.snp.makeConstraints { label in
            label.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            label.leading.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
        }
        
        mbtiCollectionView.snp.makeConstraints { collectionView in
            collectionView.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            collectionView.leading.equalTo(title.snp.trailing)
                .offset(16)
            collectionView.trailing.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            collectionView.height.equalTo(150)
        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MBTIViewCell, String> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, String>(
            collectionView: mbtiCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.configureAlphabet(itemIdentifier)
                return cell
            })
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<String, String>()
        snapShot.appendSections(["test"])
        snapShot.appendItems(["E", "I", "S", "N", "T", "F", "J", "P"], toSection: "test")
        dataSource.apply(snapShot)
    }
    
}
