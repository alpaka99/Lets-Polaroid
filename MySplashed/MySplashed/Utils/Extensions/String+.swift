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
