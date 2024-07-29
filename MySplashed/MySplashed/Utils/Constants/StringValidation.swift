//
//  StringValidation.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//

import Foundation

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
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .isEmpty:
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .isShort:
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .isLong:
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .isUsingSpecialLetter:
            return "닉네임에 @, #, $, %는 포함할 수 없어요"
        case .isUsingNumeric:
            return "닉네임에 숫자는 포함할 수 없어요"
        }
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
