//
//  TopicViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class TopicViewModel: ViewModel {
    struct Input: Equatable {
        var topicViewWillAppear = Observable(false)
    }
    
    struct Output: Equatable {
        var goldenHourItems: Observable<[TopicResponse]> = Observable([])
        var businessItems: Observable<[TopicResponse]> = Observable([])
        var architectureItems: Observable<[TopicResponse]> = Observable([])
    }
    
    var input = Input()
    var output = Output()
    
    let repository = TopicRepository()
    
    enum Action: String {
        case topicViewWillAppear
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .topicViewWillAppear:
            topicViewWillAppear()
        }
    }
    
    func configureBind() {
        bind(\.topicViewWillAppear) {[weak self] _ in
            // topic view appearing event
            // 1. api request
            TopicType.allCases.forEach { topic in
                self?.repository.requestTopic(of: topic) { value in
                    switch topic {
                    case .goldenHour:
                        self?.reduce(\.goldenHourItems.value, into: value)
                    case .business:
                        self?.reduce(\.businessItems.value, into: value)
                    case .architecture:
                        self?.reduce(\.architectureItems.value, into: value)
                    }
                }
            }
        }
    }
    
    private func topicViewWillAppear() {
        let toggledValue = !self(\.topicViewWillAppear).value
        reduce(\.topicViewWillAppear.value, into: toggledValue)
    }
}
