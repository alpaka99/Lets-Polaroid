//
//  ProfileViewController.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileView, ProfileViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "PROFILE SETTING"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.profileImage.tapGestureRecognizer.addTarget(self, action: #selector(profileImageTapped))
        baseView.nicknameTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        baseView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.bind(\.isMovingToProfileSelectionView) { _ in
            print("ProfileImageTapped")
//            navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        }
        
    }
    
    @objc
    func profileImageTapped(_ sender: UITapGestureRecognizer) {
        viewModel.react(.profileImageTapped, value: true)
    }
    
    @objc
    func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.react(.textFieldInputChanged, value: text)
        }
    }
    @objc
    func completeButtonTapped(_ sender: UIButton) {
        viewModel.react(.completeButtonTapped, value: true)
    }
}
