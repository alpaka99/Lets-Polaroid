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
    
    func returnLikedUnsplashImageData(sortOption: LikeSortOption) throws -> [UnsplashImageData] {
//        loadLikedImages()
        var unsplashImageData: [UnsplashImageData] = []
        do {
            try likedImages.forEach { likedImage in
                let convertedData = try likedImage.toUnsplashImageData()
                unsplashImageData.append(convertedData)
            }
        } catch {
            throw error
        }
        
        switch sortOption {
        case .latest:
            unsplashImageData.sort(by: {$0.unsplashResponse.createdAt < $1.unsplashResponse.createdAt})
        case .oldest:
            unsplashImageData.sort(by: {$0.unsplashResponse.createdAt >= $1.unsplashResponse.createdAt})
        }
        
        return unsplashImageData
    }
}
