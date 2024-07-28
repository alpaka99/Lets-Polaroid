//
//  ProfileSettingRepository.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//
import Foundation

final class ProfileSettingRepository {
    func createUserData(profileImage: ProfileImage, nickname: String, mbti: [MBTIGroup:MBTIComponent]) throws {
        let userData = UserData(profileImage: profileImage, nickname: nickname, mbti: mbti)
        
        try UserDefaults.standard.create(userData)
    }
    
    func readUserData() throws -> UserData? {
        let userData = try UserDefaults.standard.readAll(ofType: UserData.self)
        return userData
    }
    
    func deleteUserData() throws {
        try UserDefaults.standard.deleteAll(ofType: UserData.self)
    }
}
