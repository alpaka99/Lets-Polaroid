//
//  UserData.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//

struct UserData: Codable {
    let profileImage: ProfileImage
    let nickname: String
    let mbti: [MBTIGroup: MBTIComponent]
}
