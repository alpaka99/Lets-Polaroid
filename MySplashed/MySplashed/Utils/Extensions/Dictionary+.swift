//
//  Dictionary+.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//

import Foundation

extension Dictionary {
    func toString() throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: self)
        
        if let convertedString = String(data: jsonData, encoding: .utf8) {
            return convertedString
        }
        return ""
    }
}
