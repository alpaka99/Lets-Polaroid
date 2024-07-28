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
