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
        imageView.image.image = UIImage(named: ProfileImage.randomProfile().rawValue)
        imageView.showBadge()
        imageView.selected()
        return imageView
    }()
    private(set) var nicknameTextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 :)"
        return textField
    }()
    private let divider = {
        let view = UIView()
        view.backgroundColor = MSColor.lightGray.color
        return view
    }()
    private let validationLabel = {
        let label = UILabel()
        label.textColor = MSColor.magenta.color
        return label
    }()
    private(set) var mbtiView = {
        let view = MBTIView()
        return view
    }()
    private(set) var completeButton = {
        let button = UIButton.Configuration.plain()
            .title("완료")
            .cornerStyle(.capsule)
            .backgroundColor(MSColor.blue.color ?? .systemBlue)
            .build()
        button.tintColor = .white
        button.alpha = 0
        return button
    }()
    private(set) var deleteAccountButton = {
        let button = UIButton.Configuration.plain()
            .title("회원탈퇴")
            .backgroundColor(MSColor.white.color ?? .white)
            .build()
        button.tintColor = MSColor.blue.color
        return button
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(profileImage)
        self.addSubview(nicknameTextField)
        self.addSubview(divider)
        self.addSubview(validationLabel)
        self.addSubview(mbtiView)
        self.addSubview(completeButton)
        self.addSubview(deleteAccountButton)
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
        divider.snp.makeConstraints { divider in
            divider.top.equalTo(nicknameTextField.snp.bottom)
                .offset(16)
            divider.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges)
            divider.height.equalTo(1)
        }
        validationLabel.snp.makeConstraints { label in
            label.top.equalTo(divider.snp.bottom)
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
        deleteAccountButton.snp.makeConstraints { btn in
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
        profileImage.clipsToBounds = true
    }
    
    func configureMode(_ mode: ProfileSettingMode) {
        switch mode {
        case .onboarding:
            completeButton.alpha = 1
            deleteAccountButton.alpha = 0
        case .edit:
            completeButton.alpha = 0
            deleteAccountButton.alpha = 1
        }
    }
    
    func setValidationLabel(with text: String) {
        validationLabel.text = text
    }
    
    func setValidationLabelColor(_ value: Bool) {
        validationLabel.textColor = value ? MSColor.blue.color : MSColor.magenta.color
    }
    
    func setCompleteButtonStatus(_ isEnabled: Bool) {
        completeButton.isEnabled = isEnabled
        
        if isEnabled {
            completeButton.updateColor(MSColor.blue.color ?? .systemBlue)
            completeButton.updateForegroundColor(MSColor.white.color ?? .white)
            
        } else {
            completeButton.updateColor(MSColor.darkGray.color ?? .darkGray)
            completeButton.updateForegroundColor(MSColor.black.color ?? .black)
        }
    }
}
