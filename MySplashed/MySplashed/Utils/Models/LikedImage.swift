//
//  LikedImage.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

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

extension LikedImage {
    func toUnsplashImageData() throws -> UnsplashImageData {
        let unsplashResponseURL = try self.urls.toDictionary(keyType: String.self, valueType: String.self)
        let photographerURL = try self.photographerProfileImageURL.toDictionary(
            keyType: String.self,
            valueType: String.self
        )
        let photographer = Photographer(name: self.photographerName, profileImageURL: photographerURL)
        let unsplashResponse = UnsplashResponse(
            id: self.id,
            createdAt: self.createdAt,
            width: self.width,
            height: self.height,
            urls: unsplashResponseURL,
            likes: self.likes,
            photographer: photographer
        )
        
        
        if let image = FileManager.default.loadImageToDocument(filename: unsplashResponse.id) {
            
            let unsplashImageData = UnsplashImageData(unsplashResponse: unsplashResponse, image: image)
            
            return unsplashImageData
        } else {
            // MARK: Custom Error type으로 변경하기
            throw NSError(domain: "Empty Image", code: 123)
        }
    }
}
