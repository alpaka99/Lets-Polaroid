//
//  DetailView.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class DetailPhotoView: BaseView {
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        
        return scrollView
    }()
    private let contentView = UIView()
    
    private(set) var photoHeaderView = {
        let view = PhotoHeaderView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let image = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ProfileImage.randomProfile().rawValue)
        return imageView
    }()
    
    private let infoView = InfoView()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(photoHeaderView)
        contentView.addSubview(image)
        contentView.addSubview(infoView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        scrollView.snp.makeConstraints { scrollView in
            scrollView.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        photoHeaderView.snp.makeConstraints { header in
            header.top.horizontalEdges.equalTo(contentView)
                .inset(16)
        }
        image.snp.makeConstraints { image in
            image.top.equalTo(photoHeaderView.snp.bottom)
                .offset(16)
            image.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        infoView.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom)
                .offset(16)
            view.horizontalEdges.equalTo(photoHeaderView.snp.horizontalEdges)
            view.bottom.equalTo(contentView.snp.bottom)
        }
        
        contentView.snp.makeConstraints { view in
            view.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            view.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    func configureData(_ detailPhotoData: DetailPhotoModel) {
        setHeaderData(detailPhotoData)
        setImageData(detailPhotoData.imageData)
    }
    
    private func setHeaderData(_ data: DetailPhotoModel) {
        photoHeaderView.configureHeaderData(data)
    }
    
    private func setImageData(_ imageData: UnsplashImageData) {
        self.image.image = imageData.image
    }
}
