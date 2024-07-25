//
//  User.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

struct User: Decodable {
    let name: String
    let profileImage: [String : String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}
