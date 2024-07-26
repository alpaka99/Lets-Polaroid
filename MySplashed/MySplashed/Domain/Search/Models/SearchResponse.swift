//
//  SearchResponse.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashResponse]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
