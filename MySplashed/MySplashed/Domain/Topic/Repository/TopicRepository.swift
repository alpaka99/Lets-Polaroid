//
//  TopicRepository.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

final class TopicRepository {
    private var goldenHour: [TopicResponse] = []
    private var business: [TopicResponse] = []
    private var architecture: [TopicResponse] = []
    
    func requestTopic(of topic: TopicType, completionHandler: @escaping ([TopicResponse])->Void) {
        NetworkManager.shared.sendRequest(.topic(topic: topic), ofType: [TopicResponse].self) { value in
            completionHandler(value)
        }
    }
}
