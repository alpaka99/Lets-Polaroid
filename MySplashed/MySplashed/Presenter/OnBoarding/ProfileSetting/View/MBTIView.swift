//
//  MBTIView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class MBTIView: BaseView {
    private let title = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private(set) lazy var mbtiCollectionView  = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private(set) var dataSource: UICollectionViewDiffableDataSource<MBTISection, MBTIData>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDataSource()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(title)
        self.addSubview(mbtiCollectionView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        mbtiCollectionView.isScrollEnabled = false
        mbtiCollectionView.showsHorizontalScrollIndicator = false
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
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.22), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MBTIViewCell, MBTIData> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<MBTISection, MBTIData>(
            collectionView: mbtiCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.configureAlphabet(itemIdentifier.mbtiComponent.rawValue)
                if itemIdentifier.isSelected {
                    cell.selected()
                } else {
                    cell.deselected()
                }
                
                return cell
            })
    }
    
    func updateSnapShot(_ userMBTI: [MBTIGroup:MBTIComponent?]) {
        var snapShot = NSDiffableDataSourceSnapshot<MBTISection, MBTIData>()
        snapShot.appendSections([.main])
        MBTIComponent.allCases.forEach { component in
            if let value = userMBTI[component.group], let selectedComponent = value {
                if selectedComponent == component { // 선택된 mbti라면?
                    snapShot.appendItems([MBTIData(mbtiComponent: component, isSelected: true)], toSection: .main)
                } else {
                    snapShot.appendItems([MBTIData(mbtiComponent: component, isSelected: false)], toSection: .main)
                }
            } else { // 값이 nil임 -> 선택된 component가 없다
                snapShot.appendItems([MBTIData(mbtiComponent: component, isSelected: false)], toSection: .main)
            }
        }
        
        dataSource.apply(snapShot)
    }
}
