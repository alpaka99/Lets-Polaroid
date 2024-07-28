//
//  ProfileViewModel.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import Foundation

final class ProfileSettingViewModel: ViewModel {
    struct Input: Equatable {
        var profileImageButtonTapped = Observable(false)
        var completeButtonTapped = Observable(false)
        var textFieldInput = Observable("")
        var selectedProfileImage = Observable(ProfileImage.randomProfile())
        var profileSettingMode = Observable(ProfileSettingMode.onboarding)
    }
    
    struct Output: Equatable {
        var isMovingToProfileSelectionView = Observable(false)
        var isNicknameValidated = Observable(false)
        var isCompleteButtonEnabled = Observable(false)
        var userMBTI: Observable<[MBTIGroup : MBTIComponent?]> = Observable(MBTIComponent.initialMBTI())
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    enum Action: String {
        case profileImageTapped
        case textFieldInputChanged
        case completeButtonTapped
        case profileImageSelected
        case setProfileSettingMode
        case mbtiSelected
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .profileImageTapped:
            profileImageTapped()
        case .textFieldInputChanged:
            textFieldInputChanged(value)
        case .completeButtonTapped:
            completeButtonTapped()
        case .profileImageSelected:
            profileImageSelected(value)
        case .setProfileSettingMode:
            setProfileSettingMode(value)
        case .mbtiSelected:
            mbtiSelected(value)
        }
    }
    
    func configureBind() {
        bind(\.profileImageButtonTapped) { [weak self] value in
            self?.reduce(\.isMovingToProfileSelectionView.value, into: value)
        }
        
        bind(\.textFieldInput) { [weak self] value in
            self?.validateTextInput(value)
        }
    }
    
    private func profileImageTapped() {
        let toggledValue = !self(\.profileImageButtonTapped).value
        reduce(\.profileImageButtonTapped.value, into: toggledValue)
    }
    
    private func textFieldInputChanged<T: Equatable>(_ value: T) {
        if let value = value as? String {
            reduce(\.textFieldInput.value, into: value)
        }
    }
    
    private func completeButtonTapped() {
        
        let toggledValue = !self(\.completeButtonTapped).value
        reduce(\.completeButtonTapped.value, into: toggledValue)
    }
    
    private func validateTextInput(_ nickname: String) {
        // nickname validation logic
    }
    
    func profileImageSelected<T: Equatable>(_ profileImage: T) {
        if let profileImage = profileImage as? ProfileImage {
            reduce(\.selectedProfileImage.value, into: profileImage)
        }
    }
    
    private func setProfileSettingMode<T: Equatable>(_ value: T) {
        if let value = value as? ProfileSettingMode {
            reduce(\.profileSettingMode.value, into: value)
        }
    }
    
    private func mbtiSelected<T: Equatable>(_ selectedMBTI: T) {
        if let selectedMBTI = selectedMBTI as? MBTIData {
            let group = selectedMBTI.mbtiComponent.group
            reduce(\.userMBTI.value[group], into: selectedMBTI.mbtiComponent)
        }
    }
}

