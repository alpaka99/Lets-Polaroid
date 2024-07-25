//
//  TopicResponse.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//



struct TopicResponse: Decodable, Hashable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: [String : String]
    let likes: Int
    let user: User
    
    enum CodingKeys: String, CodingKey, Hashable {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
}

extension TopicResponse: Equatable {
    static func == (lhs: TopicResponse, rhs: TopicResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
