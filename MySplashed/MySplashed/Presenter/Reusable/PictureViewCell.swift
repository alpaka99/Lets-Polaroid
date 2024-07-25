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
    private let totalLike = {
        let button = UIButton()
            .font(ofSize: 8, weight: .regular)
            .image(systemName: "star.fill")
            .imageSize(size: 8)
            .imageColor(color: .systemYellow)
            .imagePadding(8)
            .backgroundColor(.darkGray)
            .titleColor(.white)
            .cornerStyle(.capsule)
        
        
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    private let userLike = {
        let button = UIButton()
            .image(systemName: "heart.fill")
            .cornerStyle(.capsule)
            .backgroundColor(.white.withAlphaComponent(0.5))
        button.isHidden = true
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.addSubview(imageView)
        contentView.addSubview(totalLike)
        contentView.addSubview(userLike)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        imageView.snp.makeConstraints { imageView in
            imageView.edges.equalTo(self.safeAreaLayoutGuide)
        }
        totalLike.snp.makeConstraints { btn in
            btn.leading.bottom.equalTo(self.contentView.safeAreaLayoutGuide)
                .inset(8)
        }
        userLike.snp.makeConstraints { btn in
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
        totalLike.isHidden = false
    }
    
    func showUserLike() {
        userLike.isHidden = false
    }
    
    func roundCellEdge() {
        imageView.layer.cornerRadius = 8
    }
    
    func setTotalLike(_ likes: Int) {
        totalLike.title(likes.formatted())
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

enum PictureCellType {
    case topic
    case search
    case like
}
