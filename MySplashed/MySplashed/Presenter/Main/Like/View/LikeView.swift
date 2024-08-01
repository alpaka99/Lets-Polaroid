//
//  LikeView.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class LikeView: BaseView {
    enum Section {
        case main
    }
    
    weak var delegate: LikeViewDelegate?
    
    private(set) var sortButton = {
        let button = UIButton.Configuration.plain()
            .image(named: "sort")
            .title(LikeSortOption.latest.toggled.rawValue + "으로")
            .cornerStyle(.capsule)
            .build()
        return button
    }()
    
    private let emptyView = {
        let label = UILabel()
        label.text = "저장된 사진이 없습니다"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var collectionView = { [weak self] in
        guard let view = self else { return UICollectionView(frame: .zero)}
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: view.createLayout()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alpha = 0
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section,UnsplashImageData>!
    
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
        
        self.addSubview(sortButton)
        self.addSubview(emptyView)
        self.addSubview(collectionView)
    }
    
    
    override func configureLayout() {
        super.configureLayout()
        
        sortButton.snp.makeConstraints { btn in
            btn.top.equalTo(self.safeAreaLayoutGuide)
            btn.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        emptyView.snp.makeConstraints { label in
            label.top.equalTo(sortButton.snp.bottom)
            label.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(sortButton.snp.bottom)
            collectionView.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PictureViewCell, UnsplashImageData> { cell, indexPath, itemIdentifier in
            cell.configureUI(.search)
            cell.setImage(UIImage(systemName: "star.fill")!)
            cell.setTotalLike(itemIdentifier.unsplashResponse.likes)
            cell.setLikedButton(itemIdentifier.isLiked)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UnsplashImageData>(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.setImage(itemIdentifier.image)
            cell.likeButton.tag = indexPath.row // MARK: 이 부분 수정하고 싶음
            if let view = self {
                cell.likeButton.addTarget(view, action: #selector(view.likeButtonTapped), for: .touchUpInside)
            }
            return cell
        })
    }
    
    func updateSnapShot(_ data: [UnsplashImageData]) {
        if data.isEmpty {
            setEmptyState()
        } else {
            var snapShot = NSDiffableDataSourceSnapshot<Section, UnsplashImageData>()
            
            snapShot.appendSections([.main])
            snapShot.appendItems(data, toSection: .main)
            dataSource.apply(snapShot)
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
    
    func toggleSortOption(_ sortOption: LikeSortOption) {
        sortButton.updateTitle(sortOption.rawValue + "으로")
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let data = dataSource.snapshot(for: .main).items[index]
        delegate?.likeButtonTapped(for: data)
    }
}

protocol LikeViewDelegate: AnyObject {
    func likeButtonTapped(for data: UnsplashImageData)
}

enum LikeSortOption: String {
    case latest = "최신순"
    case oldest = "오래된순"
    
    var toggled: Self {
        switch self {
        case .oldest:
            return .latest
        case .latest:
            return .oldest
        }
    }
}
