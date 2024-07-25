//
//  TopicResponse.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//



struct TopicResponse: Decodable {
    let id: String?
    let createdAt: String?
    let width: Int?
    let height: Int?
    let urls: [String : String]
    let likes: Int?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
}
