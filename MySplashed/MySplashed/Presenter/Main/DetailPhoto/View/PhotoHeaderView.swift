//
//  PhotoHeaderView.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class PhotoHeaderView: BaseView {
    private var photographerProfile = {
        let imageView = RoundImageView()
        imageView.selected()
        return imageView
    }()
    private let photographerName = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    private let photoCreated = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private lazy var nameStack = {[weak self] in
        guard let view = self else { return UIStackView() }
        let stack = UIStackView(arrangedSubviews: [view.photographerName, view.photoCreated])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private(set) var likeButton = {
        let button = UIButton.Configuration.plain()
            .image(systemName: "heart")
            .build()
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(photographerProfile)
        self.addSubview(nameStack)
        self.addSubview(likeButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        photographerProfile.snp.makeConstraints { profile in
            profile.centerY.equalTo(self.safeAreaLayoutGuide)
            profile.leading.equalTo(self.safeAreaLayoutGuide)
            profile.size.equalTo(44)
        }
        nameStack.snp.makeConstraints { stack in
            stack.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            stack.leading.equalTo(photographerProfile.snp.trailing)
                .offset(8)
        }
        likeButton.snp.makeConstraints { btn in
            btn.trailing.equalTo(self.safeAreaLayoutGuide)
            btn.centerY.equalTo(self.safeAreaLayoutGuide)
            btn.size.equalTo(44)
        }
    }
    
    func configureHeaderData(_ data: DetailPhotoModel) {
        photographerProfile.image.image = data.photographerData?.profileImage
        photographerName.text = data.photographerData?.photographer.name
        if let createdAt = DateFormatterConstant.iso8601DateFormatter.date(from: data.imageData?.unsplashResponse.createdAt ?? "") {
            DateFormatterConstant.dateFormatter.dateFormat = DateFormatterConstant.detailHeaderDateFormat
            photoCreated.text = "\(DateFormatterConstant.dateFormatter.string(from: createdAt)) 게시됨"
        }
        
        if let imageData = data.imageData, imageData.isLiked {
            likeButton.updateImage("heart.fill")
        } else {
            likeButton.updateImage("heart")
        }
    }
    
    func configureNotConnectedHeaderData(_ imageData: UnsplashImageData) {
        photographerProfile.image.image = UIImage(systemName: "person.fill")
        photographerName.text = imageData.unsplashResponse.photographer.name
        if let createdAt = DateFormatterConstant.iso8601DateFormatter.date(from: imageData.unsplashResponse.createdAt) {
            DateFormatterConstant.dateFormatter.dateFormat = DateFormatterConstant.detailHeaderDateFormat
            photoCreated.text = "\(DateFormatterConstant.dateFormatter.string(from: createdAt)) 게시됨"
        }
        
        if imageData.isLiked {
            likeButton.updateImage("heart.fill")
        } else {
            likeButton.updateImage("heart")
        }
    }
}
