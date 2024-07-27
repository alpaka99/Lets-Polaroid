//
//  LikedImage.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import RealmSwift

final class LikedImage: Object {
    // UnsplashResponse
    @Persisted(primaryKey: true) var id: String
    @Persisted var createdAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var urls: String
    @Persisted var likes: Int
    
    // Photographer
    @Persisted var photographerName: String
    @Persisted var photographerProfileImageURL: String
    
    // UnsplashImageData
    @Persisted var isLiked: Bool = false
    
    
    convenience init(unsplashImageData: UnsplashImageData) throws {
        self.init()
        self.id = unsplashImageData.unsplashResponse.id
        self.createdAt = unsplashImageData.unsplashResponse.createdAt
        self.width = unsplashImageData.unsplashResponse.width
        self.height = unsplashImageData.unsplashResponse.height
        self.urls = try unsplashImageData.unsplashResponse.urls.toString()
        self.likes = unsplashImageData.unsplashResponse.likes
        self.photographerName = unsplashImageData.unsplashResponse.photographer.name
        self.photographerProfileImageURL = try unsplashImageData.unsplashResponse.photographer.profileImageURL.toString()
        self.isLiked = unsplashImageData.isLiked
    }
}

