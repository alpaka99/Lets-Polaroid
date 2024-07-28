//
//  UserDefaults.swift
//  MySplashed
//
//  Created by user on 7/29/24.
//

import Foundation

extension UserDefaults {
    func create<T: Codable>(_ data: T) throws {
        let data = try JSONConstant.jsonEncoder.encode(data)
        
        Self.standard.setValue(data, forKey: String(describing: T.self))
    }
    
    func readAll<T: Codable>(ofType: T.Type) throws -> T? {
        guard let data = Self.standard.data(forKey: String(describing: T.self)) else { return nil}
        let convertedData = try JSONConstant.jsonDecoder.decode(T.self, from: data)
        
        return convertedData
    }
    
    func deleteAll<T: Codable>(ofType: T.Type) throws {
        Self.standard.removeObject(forKey: String(describing: T.self))
    }
}
