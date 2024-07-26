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
    
    func requestTopic(of topic: TopicType, completionHandler: @escaping ([UnsplashResponse])->Void) {
        NetworkManager.shared.sendRequest(.topic(topic: topic), ofType: [UnsplashResponse].self) { value in
            completionHandler(value)
        }
    }
    
    func requestImage(of data: [UnsplashResponse], completionHandler: @escaping ([TopicData])->Void) {
        let dispatchGroup = DispatchGroup()
        
        var topicData: [TopicData] = []
        
        for index in 0..<data.count {
            if let imageURL = data[index].urls["small_s3"], let url = URL(string: imageURL) {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let image):
                            topicData.append(TopicData(topicResponse: data[index], image: image.image))
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
