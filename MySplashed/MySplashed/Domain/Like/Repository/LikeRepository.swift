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
    
    func deleteImageData(_ imageData: UnsplashImageData, completionHandler: @escaping (Result<Bool, Error> ) throws ->Void) {
        if let target = RealmManager.shared.readAll(LikedImage.self).filter({ $0.id == imageData.unsplashResponse.id }).first {
            do {
                FileManager.default.removeImageFromDocument(filename: imageData.unsplashResponse.id)
                try RealmManager.shared.delete(target)
                try completionHandler(.success(true))
            } catch {
                print(error)
//                try completionHandler(.failure(error))
            }
        }
    }
}
