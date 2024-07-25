//
//  PictureViewCell.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

import SnapKit

final class PictureViewCell: BaseCollectionViewCell {
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .systemTeal
        return view
    }()
    let totalLike = {
        let button = UIButton()
            .title(10000.formatted())
            .font(ofSize: 12, weight: .regular)
            .image(systemName: "star.fill")
            .imageSize(size: 8)
            .imageColor(color: .systemYellow)
            .backgroundColor(.darkGray)
            .titleColor(.white)
            .cornerStyle(.capsule)
        
        
        button.isUserInteractionEnabled = false
        return button
    }()
    let userLike = {
        let button = UIButton()
            .image(systemName: "heart.fill")
            .cornerStyle(.capsule)
            .backgroundColor(.white.withAlphaComponent(0.5))
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
}
