//
//  String+.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import Foundation

extension String {
    func removeOnePrefix(_ prefix: String) -> Self {
        if self.hasPrefix(prefix) {
            let secondIndex = self.index(
                self.startIndex,
                offsetBy: 1
            )
            let result = String(self[secondIndex...])
            return result
        }
        return self
    }
    
    static var emptyString: String {
        return ""
    }
}

extension String {
    func toDictionary<T: Decodable, U: Decodable>(keyType: T.Type, valueType: U.Type) throws -> [T:U] {
        if let data = self.data(using: Self.Encoding.utf8) {
            let dictionary = try JSONConstant.jsonDecoder.decode([T : U].self, from: data)
            return dictionary
        }
        return [:]
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
