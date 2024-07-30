//
//  TopicRepository.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//
import UIKit

import Kingfisher

final class TopicRepository {
    private var goldenHour: [UnsplashResponse] = []
    private var business: [UnsplashResponse] = []
    private var architecture: [UnsplashResponse] = []
    
    private var likedImages: [LikedImage] = []
    
    func requestTopic(of topic: TopicType, completionHandler: @escaping (Result<[UnsplashResponse], TopicError>)->Void) {
        NetworkManager.shared.sendRequest(.topic(topic: topic), ofType: [UnsplashResponse].self) { result in
            switch result {
            case .success(let values):
                completionHandler(.success(values))
            case .failure:
                completionHandler(.failure(.networkManagerFetchError))
            }
        }
    }
    
    func requestImage(of data: [UnsplashResponse], completionHandler: @escaping (Result<[UnsplashImageData], TopicError>)->Void) {
        let dispatchGroup = DispatchGroup()
        
        var topicData: [UnsplashImageData] = []
        
        for index in 0..<data.count {
            if let imageURL = data[index].urls["small_s3"], let url = URL(string: imageURL) {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let image):
                            topicData.append(UnsplashImageData(unsplashResponse: data[index], image: image.image))
                        case .failure:
                            completionHandler(.failure(.kingFisherImageFetchError))
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            topicData.sort(by: {$0.unsplashResponse.likes > $1.unsplashResponse.likes})
            completionHandler(.success(topicData))
        }
    }
    
    
    func checkImageIsLiked(_ data: UnsplashImageData) -> UnsplashImageData {
        for likedImage in likedImages {
            if likedImage.id == data.unsplashResponse.id {
                var likedData = data
                likedData.isLiked = true
                return likedData
            }
        }
        return data
    }
    
    func loadLikedImages() {
        likedImages = RealmManager.shared.readAll(LikedImage.self)
    }
    
    func readAllUserData() throws -> UserData {
        let userData =  try UserDefaults.standard.readAll(ofType: UserData.self)
        if let userData = userData {
            return userData
        } else {
            throw TopicError.nilUserData
        }
    }
}

enum TopicError: Error {
    case nilUserData
    case networkManagerFetchError
    case kingFisherImageFetchError
}
