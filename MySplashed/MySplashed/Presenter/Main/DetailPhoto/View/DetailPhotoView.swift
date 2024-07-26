//
//  DetailView.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class DetailPhotoView: BaseView {
    private let photoHeaderView = {
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
        
        self.addSubview(photoHeaderView)
        self.addSubview(image)
        self.addSubview(infoView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        photoHeaderView.snp.makeConstraints { header in
            header.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        image.snp.makeConstraints { image in
            image.top.equalTo(photoHeaderView.snp.bottom)
                .offset(16)
            image.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        infoView.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom)
                .offset(16)
            view.horizontalEdges.equalTo(photoHeaderView.snp.horizontalEdges)
        }
    
    }
}
