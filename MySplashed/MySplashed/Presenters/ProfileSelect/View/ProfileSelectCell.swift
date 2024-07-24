//
//  ProfileSelectCell.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit
final class ProfileSelectCell: BaseCollectionViewCell {
    let image = {
        let imageView = RoundImageView()
        return imageView
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(image)
    }
    override func configureLayout() {
        super.configureLayout()
        
        image.snp.makeConstraints { view in
            view.center.equalTo(self)
            view.width.equalTo(self)
            view.height.equalTo(image.snp.width)
        }
    }
    
    func selected() {
        image.selected()
    }
    
    func deselected() {
        image.deselected()
    }
}
