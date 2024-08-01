//
//  SplashRepository.swift
//  MySplashed
//
//  Created by user on 7/29/24.
//

import Foundation

final class SplashRepository {
    func loadUserData() throws -> UserData? {
        let userData = try UserDefaults.standard.readAll(ofType: UserData.self)
        return userData
    }
}
