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
        var isMBTIValidated = Observable(false)
        var isCompleteButtonEnabled = Observable(false)
        var validatedNickname = Observable("")
        var userMBTI: Observable<[MBTIGroup : MBTIComponent]> = Observable(MBTIComponent.initialMBTI())
        var validationLabelText = Observable("")
        var isShowingDeleteAlert = Observable(false)
        var accountDeleted = Observable(false)
        var toastMessage = Observable("")
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
        case validateMBTI
        case checkSaveEnabled
        case isShowingDeleteAlert
        case deleteAccountButtonTapped
    }
    
    private let repository = ProfileSettingRepository()
    
    init() {
        configureBind()
        loadUserData()
        checkSaveEnabled()
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
        case .validateMBTI:
            validateMBTI()
        case .checkSaveEnabled:
            checkSaveEnabled()
        case .isShowingDeleteAlert:
            isShowingDeleteAlert()
        case .deleteAccountButtonTapped:
            deleteAccountButtonTapped()
        }
    }
    
    func configureBind() {
        bind(\.profileImageButtonTapped) { [weak self] value in
            self?.reduce(\.isMovingToProfileSelectionView.value, into: value)
        }
        
        bind(\.textFieldInput) { [weak self] value in
            guard let vm = self else { return }
            do {
                let nickname = try vm.validateTextInput(value)
                vm.reduce(\.validatedNickname.value, into: nickname)
                vm.reduce(\.validationLabelText.value, into: "사용할 수 있는 닉네임이에요")
                vm.reduce(\.isNicknameValidated.value, into: true)
            } catch {
                vm.reduce(\.validationLabelText.value, into: error.localizedDescription)
                vm.reduce(\.isNicknameValidated.value, into: false)
            }
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
    
    private func profileImageSelected<T: Equatable>(_ profileImage: T) {
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
            if let group = selectedMBTI.mbtiComponent.group {
                reduce(\.userMBTI.value[group], into: selectedMBTI.mbtiComponent)
            }
        }
    }
    
    private func validateTextInput<T: Equatable>(_ textInput: T) throws -> String {
        if let nicknameCandidate = textInput as? String {
            try nicknameCandidate.checkIsEmpty()
            try nicknameCandidate.checkStringLength()
            try nicknameCandidate.checkContainsSpecialLetter()
            try nicknameCandidate.checkNumeric()
            
            return nicknameCandidate
        } else {
            throw StringValidationError.isEmpty
        }
    }
    
    private func validateMBTI() {
        let values = self(\.userMBTI).value.values.filter {
            $0 != .none
        }
        if values.count == 4 {
            reduce(\.isMBTIValidated.value, into: true)
        } else {
            reduce(\.isMBTIValidated.value, into: false)
        }
    }
    
    private func checkSaveEnabled() {
        let isNicknameValidated = self(\.isNicknameValidated).value
        let isMBTIValidated = self(\.isMBTIValidated).value
        
        reduce(\.isCompleteButtonEnabled.value, into: isNicknameValidated && isMBTIValidated)
    }
    
    private func completeButtonTapped() {
        
        let profileImage = self(\.selectedProfileImage).value
        let nickname = self(\.validatedNickname).value
        let mbti = self(\.userMBTI).value
        var convertedMBTI = [MBTIGroup:MBTIComponent]()
        mbti.keys.forEach { key in
            if let value = mbti[key] {
                convertedMBTI[key] = value
            }
        }
        do {
            try repository.createUserData(profileImage: profileImage, nickname: nickname, mbti: convertedMBTI)
            
            let toggledValue = !self(\.completeButtonTapped).value
            reduce(\.completeButtonTapped.value, into: toggledValue)
        } catch {
            reduce(\.toastMessage.value, into: "사용자 데이터 생성 에러")
        }
    }
    
    private func loadUserData() {
        do {
            let userData = try repository.readUserData()
            if let userData = userData {
                reduce(\.selectedProfileImage.value, into: userData.profileImage)
                reduce(\.textFieldInput.value, into: userData.nickname)
                reduce(\.userMBTI.value, into: userData.mbti)
                
            }
        } catch {
            reduce(\.toastMessage.value, into: "사용자 데이터 불러오기 에러")
        }
    }
    
    private func isShowingDeleteAlert() {
        let toggledValue = !self(\.isShowingDeleteAlert).value
        reduce(\.isShowingDeleteAlert.value, into: toggledValue)
    }
    
    private func deleteAccountButtonTapped() {
        do {
            try repository.deleteUserData()
            let toggledData = !self(\.accountDeleted).value
            reduce(\.accountDeleted.value, into: toggledData)
        } catch {
            reduce(\.toastMessage.value, into: "계정 삭제 실패")
        }
    }
}
