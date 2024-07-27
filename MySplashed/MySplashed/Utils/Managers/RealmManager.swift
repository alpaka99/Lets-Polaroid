//
//  RealmManager.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()
    
    private init() { }
    
    func create<T: Object>(_ data: T) throws {
        try realm.write {
            realm.add(data)
        }
    }
    
    func readAll<T: Object>(_ dataType: T.Type) throws -> [T] {
        return Array(realm.objects(dataType.self))
    }
    
    func update<T: Object>(target: T, into newValue: T) throws {
        try realm.write {
            realm.create(T.self, value: newValue, update: .modified)
        }
    }
    
    func delete<T: Object>(_ data: T) throws {
        try realm.write {
            realm.delete(data)
        }
    }
}
