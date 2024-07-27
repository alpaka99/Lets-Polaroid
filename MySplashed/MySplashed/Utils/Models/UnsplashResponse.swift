//
//  TopicResponse.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

struct UnsplashResponse: Decodable, Hashable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: [String : String]
    let likes: Int
    let photographer: Photographer
    
    enum CodingKeys: String, CodingKey, Hashable {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case photographer = "user"
    }
}

extension UnsplashResponse: Equatable {
    static func == (lhs: UnsplashResponse, rhs: UnsplashResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
