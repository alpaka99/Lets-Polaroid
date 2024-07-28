//
//  ProfileImage.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

enum ProfileImage: String, CaseIterable, Codable {
    case profile0 = "profile_0"
    case profile1 = "profile_1"
    case profile2 = "profile_2"
    case profile3 = "profile_3"
    case profile4 = "profile_4"
    case profile5 = "profile_5"
    case profile6 = "profile_6"
    case profile7 = "profile_7"
    case profile8 = "profile_8"
    case profile9 = "profile_9"
    case profile10 = "profile_10"
    case profile11 = "profile_11"
    
    static func randomProfile() -> Self {
        return Self.allCases.randomElement() ?? .profile0
    }
    
    static var allData: [ProfileImageData] {
        return Self.allCases.map {
            $0.data
        }
    }
    
    var data: ProfileImageData {
        return ProfileImageData(imageName: self.rawValue)
    }
}

struct ProfileImageData: Equatable, Hashable {
    var imageName: String
    var isSelected: Bool = false
}
