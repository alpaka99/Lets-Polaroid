//
//  DetailPhotoRepository.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

import Kingfisher
final class DetailPhotoRepository {
    var likedImages = Set<String>()
    
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
    
    private func loadLikedImages() {
        likedImages = Set(RealmManager.shared.readAll(LikedImage.self).map {$0.id})
    }
    
    func checkDataLike(_ data: UnsplashImageData) -> UnsplashImageData {
        loadLikedImages()
        
        var returnData = data
        if likedImages.contains(data.unsplashResponse.id) {
            returnData.isLiked = true
        } else {
            returnData.isLiked = false
        }
        
        return returnData
    }
    
    func toggleDataLike(_ data: UnsplashImageData) -> UnsplashImageData {
        loadLikedImages()
        
        var toggledData = data
        toggledData.isLiked.toggle()
        
        realmLikeAction(toggledData)
        return toggledData
    }
    
    func realmLikeAction(_ data: UnsplashImageData) {
        do {
            if data.isLiked {
                let realmImageData = try makeRealmImageData(with: data)
                try RealmManager.shared.create(realmImageData)
                FileManager.default.saveImageToDocument(image: data.image, filename: data.unsplashResponse.id)
            } else {
                if let target = RealmManager.shared.readAll(LikedImage.self).filter({$0.id == data.unsplashResponse.id}).first {
                    FileManager.default.removeImageFromDocument(filename: data.unsplashResponse.id)
                    try RealmManager.shared.delete(target)
                }
            }
        } catch {
            print("toggle data error")
        }
    }
    
    private func makeRealmImageData(with data: UnsplashImageData) throws -> LikedImage {
        let likedImage = try LikedImage(unsplashImageData: data)
        return likedImage
    }
}
