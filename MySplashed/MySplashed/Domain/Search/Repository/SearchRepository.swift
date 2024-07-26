//
//  SearchRepository.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

import Kingfisher

final class SearchRepository {
    func requestSearchImage(_ searchText: String, completionHandler: @escaping ([UnsplashImageData])->Void) {
        NetworkManager.shared.sendRequest(.search(searchText: searchText), ofType: SearchResponse.self) {[weak self] searchResponse in
            self?.requestImage(of: searchResponse.results) { imageResponse in
                completionHandler(imageResponse)
            }
        }
    }
    
    func prefetchImage(_ searchText: String, page: Int, completionHandler: @escaping ([UnsplashImageData])->Void) {
        print(#function, page)
        NetworkManager.shared.sendRequest(.search(searchText: searchText, page: page), ofType: SearchResponse.self) {[weak self] searchResponse in
            self?.requestImage(of: searchResponse.results) { imageResponse in
                completionHandler(imageResponse)
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
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let image):
                            topicData.append(UnsplashImageData(unsplashResponse: data[index], image: image.image))
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
}
