//
//  LikeRepository.swift
//  MySplashed
//
//  Created by user on 7/28/24.
//

import Foundation

final class LikeRepository {
    var likedImages: [LikedImage] = []
    
    func loadLikedImages() {
        likedImages = RealmManager.shared.readAll(LikedImage.self)
    }
    
    func returnLikedUnsplashImageData() throws -> [UnsplashImageData] {
        loadLikedImages()
        var unsplashImageData: [UnsplashImageData] = []
        do {
            try likedImages.forEach { likedImage in
                let convertedData = try likedImage.toUnsplashImageData()
                unsplashImageData.append(convertedData)
            }
        } catch {
            throw error
        }
        return unsplashImageData
    }
}
