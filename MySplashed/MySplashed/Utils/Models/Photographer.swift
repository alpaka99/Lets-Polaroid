//
//  User.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//
import Foundation

struct Photographer: Decodable, Hashable {
    let name: String
    let profileImageURL: [String : String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImageURL = "profile_image"
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

extension Dictionary {
    func toString<T: Encodable>(_ dictionary: T = self) throws -> String {
        let jsonData = try JSONConstant.jsonEncoder.encode(dictionary)
        
        if let convertedString = String(data: jsonData, encoding: .utf8) {
            return convertedString
        }
        return ""
    }
}
