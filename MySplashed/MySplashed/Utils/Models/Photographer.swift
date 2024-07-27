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
