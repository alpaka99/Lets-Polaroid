//
//  RoundImageView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class RoundImageView: BaseView {
    private(set) var image = {
        let imageView = UIImageView()
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let badge = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    private let badgeBackground = {
        let view = UIView()
        view.backgroundColor = MSColor.blue.color
        return view
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(image)
        self.addSubview(badgeBackground)
        badgeBackground.addSubview(badge)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        image.snp.makeConstraints { view in
            view.center.equalTo(self.safeAreaLayoutGuide)
            view.height.equalTo(self.safeAreaLayoutGuide.snp.height)
            view.width.equalTo(image.snp.height)
        }
        badgeBackground.snp.makeConstraints { view in
            view.size.equalTo(self)
                .multipliedBy(0.3)
            view.bottom.trailing.equalTo(self)
        }
        badge.snp.makeConstraints { badge in
            badge.edges.equalTo(badgeBackground)
                .inset(4)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        deselected()
        hideBadge()
    }
    
    func setProfileImage(_ profileImage: ProfileImage) {
        image.image = UIImage(named: profileImage.rawValue)
    }
    
    func selected() {
        image.layer.borderColor = MSColor.blue.color?.cgColor
        image.layer.borderWidth = 5
        image.alpha = 1
    }
    
    func deselected() {
        image.layer.borderWidth = 1
        image.layer.borderColor = MSColor.black.color?.cgColor
        image.alpha = 0.5
    }
    
    
    func hideBadge() {
        badge.isHidden = true
        badgeBackground.isHidden = true
    }
    
    func showBadge() {
        badge.isHidden = false
        badgeBackground.isHidden = false
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        image.layer.cornerRadius = image.frame.height / 2
        image.clipsToBounds = true
        
        badgeBackground.layer.cornerRadius = badgeBackground.frame.height / 2
        badge.clipsToBounds = true
    }
}
