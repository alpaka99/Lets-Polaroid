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
        var nickname = Observable("")
        var userMBTI: Observable<[MBTIGroup : MBTIComponent?]> = Observable(MBTIComponent.initialMBTI())
        var validationLabelText = Observable("")
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
            guard let vm = self else { return }
            do {
                let nickname = try vm.validateTextInput(value)
                vm.reduce(\.nickname.value, into: nickname)
                vm.reduce(\.validationLabelText.value, into: "사용가능한 닉네임입니다")
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
    
    private func completeButtonTapped() {
        
        let toggledValue = !self(\.completeButtonTapped).value
        reduce(\.completeButtonTapped.value, into: toggledValue)
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
            let group = selectedMBTI.mbtiComponent.group
            reduce(\.userMBTI.value[group], into: selectedMBTI.mbtiComponent)
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
}

enum StringValidationError: Error {
    case isNil
    case isEmpty
    case isShort
    case isLong
    case isUsingSpecialLetter
    case isUsingNumeric
}

extension StringValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .isNil:
            return "빈 값을 사용할 수 없습니다"
        case .isEmpty:
            return "빈 값을 사용할 수 없습니다"
        case .isShort:
            return "닉네임은 2글자 이상이어야합니다"
        case .isLong:
            return "닉네임은 8글자 이하이어야합니다"
        case .isUsingSpecialLetter:
            return "닉네임에 @, #, $, %는 사용할 수 없습니다"
        case .isUsingNumeric:
            return "닉네임에 숫자를 사용할 수 없습니다"
        }
    }
}

extension String {
    internal func checkIsEmpty() throws {
        guard self.isEmpty == false else { throw StringValidationError.isEmpty }
    }
    
    internal func checkStringLength() throws {
        guard self.count >= 2 else { throw StringValidationError.isShort }
        guard self.count <= 10 else { throw StringValidationError.isLong }
    }
    
    internal func checkContainsSpecialLetter() throws {
        let specialLetters: [Character] = SpecialLetterConstants.allStringCases
        
        try specialLetters.forEach { specialLetter in
            if self.contains(where: {$0 == specialLetter}) {
                throw StringValidationError.isUsingSpecialLetter
            }
        }
    }
    
    internal func checkNumeric() throws {
        guard !self.contains(where: {$0.isNumber}) else { throw StringValidationError.isUsingNumeric }
    }
}

enum SpecialLetterConstants:Character, CaseIterable {
    case at = "@"
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
    
    static var allStringCases: [Character] {
        var allRawValue: [Character] = []
        
        Self.allCases.forEach { specialString in
            allRawValue.append(specialString.rawValue)
        }
        return allRawValue
    }
}
