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
        try deleteLikedImageData()
        try UserDefaults.standard.deleteAll(ofType: UserData.self)
    }
    
    private func deleteLikedImageData() throws {
        let likedImages = RealmManager.shared.readAll(LikedImage.self)
        try likedImages.forEach { imageData in
            try FileManager.default.removeImageFromDocument(filename: imageData.id)
            try RealmManager.shared.delete(imageData)
        }
    }
}

enum ProfileSettingError: Error {
    case realmDeleteError
    case photoFileDeleteError
    case userDefaultsDeleteError
}
