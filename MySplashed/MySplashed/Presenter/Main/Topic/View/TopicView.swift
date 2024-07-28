//
//  TopicView.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TopicView: BaseView {
    
    
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: UICollectionViewDiffableDataSource<TopicSection, UnsplashImageData>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDataSource()
        configureSnapShot()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(collectionView)
    }
    
    
    override func configureLayout() {
        super.configureLayout()
        
        collectionView.snp.makeConstraints { collection in
            collection.edges.equalTo(self.safeAreaLayoutGuide)
                .inset(8)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let supplymentaryHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: "CollectionViewHeader",
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [supplymentaryHeader]
            section.supplementariesFollowContentInsets = false
            
            return section
        }, configuration: config)
        
        return layout
    }
    
    func configureDataSource() {
        var cellRegistration = UICollectionView.CellRegistration<PictureViewCell, UnsplashImageData> { cell, indexPath, itemIdentifier in
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<TopicSection, UnsplashImageData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.configureUI(.topic)
            cell.setTotalLike(itemIdentifier.unsplashResponse.likes)
            cell.setImage(itemIdentifier.image)
            return cell
        })
        
        let supplymentaryRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeader>(elementKind: "CollectionViewHeader") { supplementaryView, elementKind, indexPath in
            let sectionKind = TopicSection.allCases[indexPath.section]
            supplementaryView.label.text = sectionKind.rawValue
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplymentaryRegistration, for: indexPath)
        }
    }
    
    func configureSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<TopicSection, UnsplashImageData>()
        snapShot.appendSections(TopicSection.allCases)
        dataSource.apply(snapShot)
    }
    
    func updateSnapShot(_ data: [UnsplashImageData], sectionType: TopicSection) {
        
        var snapShot = dataSource.snapshot(for: sectionType)
        
        snapShot.deleteAll()
        snapShot.append(data)
        
        dataSource.apply(snapShot, to: sectionType)
    }
}


final class CollectionViewHeader: UICollectionReusableView {
    lazy var label = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = MSColor.darkGray.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(label)
    }
    
    func configureLayout() {
        label.snp.makeConstraints { label in
            label.edges.equalTo(self)
                .inset(16)
        }
    }
    
    func configureData(_ text: String) {
        label.text = text
    }
}

enum TopicSection: String, CaseIterable {
    case goldenHour = "골든 아워"
    case business = "비즈니스 및 업무"
    case architecture = "건축 및 인테리어"
    
    static func intInit(_ index: Int) -> Self? {
        let allCases = Self.allCases
        if index < allCases.count {
            return allCases[index]
        }
        return nil
    }
}
