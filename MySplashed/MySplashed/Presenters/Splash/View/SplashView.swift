//
//  SplashView.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import UIKit

import SnapKit

final class SplashView: BaseView {
    private let launchTitle = {
        let label = UILabel()
        label.text = "HELLO.\nMY SPLASHED🎨"
        label.numberOfLines = 0
        label.textColor = MSColor.blue.color
        label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        return label
    }()
    
    private let launchImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchImage")
        return imageView
    }()
    
    private let developerName = {
        let label = UILabel()
        label.text = "고석환"
        label.textColor = MSColor.black.color
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private(set) var startButton = {
        let button = UIButton()
            .title("시작하기")
            .backgroundColor(MSColor.blue.color ?? .systemBlue)
            .font(ofSize: 16, weight: .semibold)
            .cornerStyle(.capsule)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(launchTitle)
        self.addSubview(launchImage)
        self.addSubview(developerName)
        self.addSubview(startButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        launchTitle.snp.makeConstraints { label in
            label.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(20)
        }
        launchImage.snp.makeConstraints { image in
            image.top.equalTo(launchTitle.snp.bottom)
                .offset(20)
            image.centerX.equalTo(self.snp.centerX)
        }
        developerName.snp.makeConstraints { label in
            label.top.equalTo(launchImage.snp.bottom)
                .offset(12)
            label.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        startButton.snp.makeConstraints { button in
            button.top.greaterThanOrEqualTo(developerName.snp.bottom)
                .offset(20)
            button.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(20)
            button.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(20)
            button.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.alpha = 0
        UIView.animate(withDuration: 2) { [weak self] in
            self?.alpha = 1
        } completion: { [weak self] _ in
            self?.startButton.isHidden = false
        }
    }
}
