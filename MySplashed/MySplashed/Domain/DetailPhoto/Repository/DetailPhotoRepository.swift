//
//  DetailPhotoRepository.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

import Kingfisher
final class DetailPhotoRepository {
    func requestImage(of photographer: Photographer, completionHandler: @escaping (PhotographerData)->Void) {
        if let imageURL = photographer.profileImageURL["large"], let url = URL(string: imageURL) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let image):
                    let photographerData = PhotographerData(
                        photographer: photographer,
                        profileImage: image.image
                    )
                    completionHandler(photographerData)
                case .failure(let error):
                    print("KingFisher ImageFetch Error", error)
                }
            }
        }
    }
    
    func toggleDataLike(_ data: UnsplashImageData) -> UnsplashImageData {
        var toggledData = data
        toggledData.isLiked.toggle()
        
        do {
            let realmImage = try makeRealmImage(with: toggledData)
            if realmImage.isLiked {
                try RealmManager.shared.create(realmImage)
                FileManager.default.saveImageToDocument(image: toggledData.image, filename: realmImage.id)
            } else {
                if let target = RealmManager.shared.readAll(LikedImage.self).filter({$0.id == data.unsplashResponse.id}).first {
                    FileManager.default.removeImageFromDocument(filename: data.unsplashResponse.id)
                    try RealmManager.shared.delete(target)
                }
            }
        } catch {
            print("toggle data error")
        }
        return toggledData
    }
    
    private func makeRealmImage(with data: UnsplashImageData) throws -> LikedImage {
        let likedImage = try LikedImage(unsplashImageData: data)
        return likedImage
    }
}
