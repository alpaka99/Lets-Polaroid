//
//  DetailPhotoRepository.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

import Alamofire
import Kingfisher

final class DetailPhotoRepository {
    var likedImages = Set<String>()
    
    func requestImage(of photographer: Photographer, completionHandler: @escaping (Result<PhotographerData, DetailRepositoryError>)->Void) {
        if let imageURL = photographer.profileImageURL["large"], let url = URL(string: imageURL) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let image):
                    let photographerData = PhotographerData(
                        photographer: photographer,
                        profileImage: image.image
                    )
                    completionHandler(.success(photographerData))
                case .failure:
                    completionHandler(.failure(.photographerFetchFailure))
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
    
    private func realmLikeAction(_ data: UnsplashImageData) {
        do {
            if data.isLiked {
                let realmImageData = try makeRealmImageData(with: data)
                try RealmManager.shared.create(realmImageData)
                try FileManager.default.saveImageToDocument(image: data.image, filename: data.unsplashResponse.id)
            } else {
                if let target = RealmManager.shared.readAll(LikedImage.self).filter({$0.id == data.unsplashResponse.id}).first {
                    try FileManager.default.removeImageFromDocument(filename: data.unsplashResponse.id)
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
    
    func requestStatisticsData(with data: UnsplashImageData, completionHandler: @escaping (Result<StatisticsData, DetailRepositoryError>)->Void)  {
        let id = data.unsplashResponse.id
        do {
            let url = try Router.statistic(imageID: id).asURLRequest()
            
            AF.request(url)
                .responseDecodable(of: StatisticsData.self) { response in
                    switch response.result {
                    case .success(let value):
                        completionHandler(.success(value))
                    case .failure(_):
                        completionHandler(.failure(.statisticsFetchFailure))
                    }
                }
        } catch {
            completionHandler(.failure(.statisticsFetchFailure))
        }
    }
}

enum DetailRepositoryError: Error {
    case statisticsFetchFailure
    case photographerFetchFailure
}
