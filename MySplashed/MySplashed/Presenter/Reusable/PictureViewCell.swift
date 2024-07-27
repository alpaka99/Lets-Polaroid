//
//  PictureViewCell.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

import SnapKit

final class PictureViewCell: BaseCollectionViewCell {
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let totalLikes = {
        let button = UIButton.Configuration.plain()
            .font(ofSize: 8, weight: .regular)
            .image(systemName: "star.fill")
            .imageSize(size: 8)
            .imageColor(color: .systemYellow)
            .imagePadding(8)
            .backgroundColor(.darkGray)
            .foregroundColor(.white)
            .cornerStyle(.capsule)
            .build()
        
        
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    private(set) var likeButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "heart.fill")
            .cornerStyle(.capsule)
            .backgroundColor(.white.withAlphaComponent(0.5))
            .build()
        
        button.isHidden = true
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(imageView)
        contentView.addSubview(totalLikes)
        contentView.addSubview(likeButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints { imageView in
            imageView.edges.equalTo(self.safeAreaLayoutGuide)
        }
        totalLikes.snp.makeConstraints { btn in
            btn.leading.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
                .inset(8)
        }
        likeButton.snp.makeConstraints { btn in
            btn.trailing.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
                .inset(8)
        }
    }
    
    func configureUI(_ type: PictureCellType) {
        switch type {
        case .topic:
            showTotalLike()
            roundCellEdge()
        case .search:
            showTotalLike()
            showUserLike()
        case .like:
            showUserLike()
        }
    }
    
    func showTotalLike() {
        totalLikes.isHidden = false
    }
    
    func showUserLike() {
        likeButton.isHidden = false
    }
    
    func roundCellEdge() {
        imageView.layer.cornerRadius = 8
    }
    
    func setTotalLike(_ likes: Int) {
        let config = totalLikes.configuration?.title(likes.formatted())
        totalLikes.configuration = config
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setLikedButton(_ isLiked: Bool) {
        if isLiked {
            likeButton.updateImge("heart.fill")
        } else {
            likeButton.updateImge("heart")
        }
    }
}

enum PictureCellType {
    case topic
    case search
    case like
}
