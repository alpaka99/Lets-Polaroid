//
//  ProfileViewController.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingView, ProfileSettingViewModel> {
    
    convenience init(baseView: ProfileSettingView, viewModel: ProfileSettingViewModel, mode: ProfileSettingMode) {
        self.init(baseView: baseView, viewModel: viewModel)
        viewModel.react(.setProfileSettingMode, value: mode)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.profileImage.tapGestureRecognizer.addTarget(self, action: #selector(profileImageTapped))
        baseView.nicknameTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        baseView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        baseView.deleteAccountButton.addTarget(self, action: #selector(showDeleteAlert), for: .touchUpInside)
        
        baseView.mbtiView.mbtiCollectionView.delegate = self
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.actionBind(\.profileSettingMode) {[weak self] mode in
            self?.baseView.configureMode(mode)
            switch mode {
            case .onboarding:
                self?.navigationItem.title = "PROFILE SETTING"
            case .edit:
                self?.navigationItem.title = "Edit Profile"
                let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(self?.saveButtonTapped))
                self?.navigationItem.rightBarButtonItem = saveButton
            }
        }
        
        viewModel.actionBind(\.selectedProfileImage) {[weak self] profileImage in
            self?.baseView.profileImage.setProfileImage(profileImage)
        }
        
        viewModel.bind(\.isMovingToProfileSelectionView) {[weak self] _ in
            if let selectedImage = self?.viewModel(\.selectedProfileImage).value {
                
                let profileSelectViewController = ProfileSelectViewController(baseView: ProfileSelectView(), viewModel: ProfileSelectViewModel(), profileImage: selectedImage)
                
                profileSelectViewController.delegate = self
                
                
                self?.navigationController?.pushViewController(
                    profileSelectViewController,
                    animated: true)
            }
        }
        
        viewModel.actionBind(\.validatedNickname) {[weak self] value in
            self?.baseView.nicknameTextField.text = value
        }
        
        viewModel.actionBind(\.validationLabelText) {[weak self] value in
            self?.baseView.setValidationLabel(with: value)
        }
        
        viewModel.actionBind(\.isNicknameValidated) {[weak self] value in
            self?.baseView.setValidationLabelColor(value)
            self?.viewModel.react(.checkSaveEnabled, value: true)
        }
        
        viewModel.actionBind(\.userMBTI) {[weak self] value in
            self?.baseView.mbtiView.updateSnapShot(value)
            self?.viewModel.react(.validateMBTI, value: true)
            self?.viewModel.react(.checkSaveEnabled, value: true)
        }
        
        viewModel.actionBind(\.isCompleteButtonEnabled) {[weak self] value in
            self?.baseView.setCompleteButtonStatus(value)
            self?.navigationItem.rightBarButtonItem?.isEnabled = value
        }
    
        viewModel.bind(\.completeButtonTapped) {[weak self] _ in
            self?.setNewViewController(nextViewController: TabBarController(), isNavigation: false)
        }
        
        viewModel.bind(\.isShowingDeleteAlert) {[weak self] _ in
            self?.showAlert(alertData: [AlertData(title: "삭제", style: .destructive, closure: {
                self?.deleteAccountButtonTapped()
            })])
        }
        
        viewModel.bind(\.accountDeleted) {[weak self] _ in
            self?.setNewViewController(nextViewController: SplashViewController(baseView: SplashView(), viewModel: SplashViewModel()), isNavigation: true)
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
    
    @objc
    func saveButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.react(.completeButtonTapped, value: true)
    }
    
    @objc
    func showDeleteAlert(_ sender: UIButton) {
        viewModel.react(.isShowingDeleteAlert, value: true)
    }
    
    
    func deleteAccountButtonTapped() {
        viewModel.react(.deleteAccountButtonTapped, value: true)
    }
}

extension ProfileSettingViewController: ProfileSelectViewControllerDelegate {
    func profileImageSelected(_ profileImage: ProfileImage) {
        viewModel.react(.profileImageSelected, value: profileImage)
    }
}

extension ProfileSettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMBTI = baseView.mbtiView.dataSource.snapshot(for: .main).items[indexPath.row]
        viewModel.react(.mbtiSelected, value: selectedMBTI)
    }
}

enum ProfileSettingMode: Int {
    case onboarding = 0
    case edit = 1
}

extension UIViewController {
    func showAlert(alertData: [AlertData]) {
        let ac = UIAlertController(title: "계정 삭제", message: "MySplashed 계정을 삭제하실건가요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        ac.addAction(cancelAction)
        alertData.forEach { data in
            let alertAction = UIAlertAction(title: data.title, style: data.style) { _ in
                data.closure()
            }
            ac.addAction(alertAction)
        }
        
        self.present(ac, animated: true)
    }
}

struct AlertData {
    let title: String
    let style: UIAlertAction.Style
    let closure: ()->()
}
