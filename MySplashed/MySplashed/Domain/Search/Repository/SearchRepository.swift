//
//  SearchRepository.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

import Kingfisher

final class SearchRepository {
    var relavantImageData: [UnsplashImageData] = []
    var latestImageData: [UnsplashImageData] = []
    var likedImageId = Set<String>()
    
    init() {
        loadLikedImage()
    }
    
    func requestSearchImage(_ searchText: String, sortOption: SearchSortOption, completionHandler: @escaping ([UnsplashImageData])->Void) {
        NetworkManager.shared.sendRequest(.search(searchText: searchText), ofType: SearchResponse.self) {[weak self] searchResponse in
            if let repo = self {
                repo.requestImage(of: searchResponse.results) { imageResponse in
                    repo.relavantImageData = []
                    repo.latestImageData = []
                    let imageData = repo.returnImageData(imageResponse, sortOption: sortOption)
                    completionHandler(imageData)
                }
            }
        }
    }
    
    func prefetchImage(_ searchText: String, page: Int, sortOption: SearchSortOption, completionHandler: @escaping ([UnsplashImageData])->Void) {
        NetworkManager.shared.sendRequest(.search(searchText: searchText, page: page), ofType: SearchResponse.self) {[weak self] searchResponse in
            if let repo = self {
                repo.requestImage(of: searchResponse.results) { imageResponse in
                    let imageData = repo.returnImageData(imageResponse, sortOption: sortOption)
                    completionHandler(imageData)
                }
            }
        }
    }
    
    private func requestImage(of data: [UnsplashResponse], completionHandler: @escaping ([UnsplashImageData])->Void) {
        let dispatchGroup = DispatchGroup()
        
        var topicData: [UnsplashImageData] = []
        
        for index in 0..<data.count {
            if let imageURL = data[index].urls["small_s3"], let url = URL(string: imageURL) {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                    KingfisherManager.shared.retrieveImage(with: url) {[weak self] result in
                        switch result {
                        case .success(let image):
                            var imageData = UnsplashImageData(unsplashResponse: data[index], image: image.image)
                            if let isLiked = self?.likedImageId.contains(imageData.unsplashResponse.id) {
                                imageData.isLiked = isLiked
                            }
                            topicData.append(imageData)
                        case .failure(let error):
                            print("KingFisher ImageFetch Error", error)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(topicData)
        }
    }
    
    func returnImageData(_ imageData: [UnsplashImageData], sortOption: SearchSortOption) -> [UnsplashImageData] {
        relavantImageData.append(contentsOf: imageData)
        latestImageData = relavantImageData.sorted(by: { $0.unsplashResponse.createdAt <= $1.unsplashResponse.createdAt })
        
        switch sortOption {
        case .relevant:
            return relavantImageData
        case .latest:
            return latestImageData
        }
    }
    
    func loadLikedImage() {
        let likedImages = RealmManager.shared.readAll(LikedImage.self)
        likedImageId = Set(likedImages.map({ likedImage in
            likedImage.id
        }))
    }
    
    func changeLikeStatus(of data: UnsplashImageData, sortOption: SearchSortOption) -> [UnsplashImageData] {
        loadLikedImage()
        
        // MARK: 추후에 조금 더 효율적인 방법 생각해보기
        if likedImageId.contains(data.unsplashResponse.id) { // undo like operation
            toggleLike(of: data, with: true)
        } else { // do like operation
            toggleLike(of: data, with: false)
        }
        
        switch sortOption {
        case .relevant:
            return relavantImageData
        case .latest:
            return latestImageData
        }
    }
    
    private func toggleLike(of data: UnsplashImageData, with isLiked: Bool) {
        for index in 0..<latestImageData.count {
            var targetData = latestImageData[index]
            if targetData.unsplashResponse.id == data.unsplashResponse.id {
                targetData.isLiked = isLiked
                latestImageData[index] = targetData
                break
            }
        }
        
        for index in 0..<relavantImageData.count {
            var targetData = relavantImageData[index]
            if targetData.unsplashResponse.id == data.unsplashResponse.id {
                targetData.isLiked = isLiked
                relavantImageData[index] = targetData
                break
            }
        }
    }
}
