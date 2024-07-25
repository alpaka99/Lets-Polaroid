//
//  ProfileView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class ProfileSettingView: BaseView {
    private(set) var profileImage = {
        let imageView = RoundImageView()
        imageView.image.image = UIImage(named: "profile_0")
        imageView.showBadge()
        imageView.selected()
        return imageView
    }()
    private(set) var nicknameTextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        return textField
    }()
    private let validationLabel = {
        let label = UILabel()
        label.textColor = MSColor.magenta.color
        label.text = "validation label"
        return label
    }()
    private let mbtiView = {
        let view = MBTIView()
        return view
    }()
    private(set) var completeButton = {
        let button = UIButton()
            .title("완료")
            .cornerStyle(.capsule)
            .backgroundColor(MSColor.blue.color ?? .systemBlue)
        button.tintColor = .white
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(profileImage)
        self.addSubview(nicknameTextField)
        self.addSubview(validationLabel)
        self.addSubview(mbtiView)
        self.addSubview(completeButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        profileImage.snp.makeConstraints { btn in
            btn.top.equalTo(self.safeAreaLayoutGuide)
                .offset(16)
            btn.centerX.equalTo(self.snp.centerX)
            btn.width.equalTo(self.snp.width)
                .multipliedBy(0.3)
            btn.height.equalTo(profileImage.snp.width)
        }
        nicknameTextField.snp.makeConstraints { textField in
            textField.top.equalTo(profileImage.snp.bottom)
                .offset(16)
            textField.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        validationLabel.snp.makeConstraints { label in
            label.top.equalTo(nicknameTextField.snp.bottom)
                .offset(16)
            label.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges)
        }
        mbtiView.snp.makeConstraints { view in
            view.top.equalTo(validationLabel.snp.bottom)
                .offset(16)
            view.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        completeButton.snp.makeConstraints { btn in
            btn.top.greaterThanOrEqualTo(mbtiView.snp.bottom)
                .offset(16)
            btn.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges)
            btn.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            btn.height.equalTo(44)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        profileImage.layer.cornerRadius = self.frame.height  / 2
        profileImage.clipsToBounds = true
    }
}
