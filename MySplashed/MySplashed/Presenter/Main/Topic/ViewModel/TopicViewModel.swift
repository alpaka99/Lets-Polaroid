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
        var goldenHourResponse: Observable<[UnsplashResponse]> = Observable([])
        var businessResponse: Observable<[UnsplashResponse]> = Observable([])
        var architectureResponse: Observable<[UnsplashResponse]> = Observable([])
    }
    
    struct Output: Equatable {
        var goldenHourData: Observable<[UnsplashImageData]> = Observable([])
        var businessData: Observable<[UnsplashImageData]> = Observable([])
        var architectureData: Observable<[UnsplashImageData]> = Observable([])
    }
    
    var input = Input()
    var output = Output()
    
    let repository = TopicRepository()
    
    enum Action: String {
        case topicViewWillAppear
        case loadTopics
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .topicViewWillAppear:
            topicViewWillAppear()
        case .loadTopics:
            loadTopics()
        }
    }
    
    func configureBind() {
        bind(\.topicViewWillAppear) {[weak self] _ in
            // topic view appearing event
            self?.react(.loadTopics, value: true)
        }
        
        bind(\.goldenHourResponse) {[weak self] value in
            self?.loadImages(type: .goldenHour, with: value)
        }
        
        bind(\.businessResponse) {[weak self] value in
            self?.loadImages(type: .business, with: value)
        }
        
        bind(\.architectureResponse) {[weak self] value in
            self?.loadImages(type: .architecture, with: value)
        }
    }
    
    private func topicViewWillAppear() {
        let toggledValue = !self(\.topicViewWillAppear).value
        reduce(\.topicViewWillAppear.value, into: toggledValue)
    }
    
    private func loadTopics() {
        TopicType.allCases.forEach {[weak self] topic in
            self?.repository.requestTopic(of: topic) { value in
                switch topic {
                case .goldenHour:
                    self?.reduce(\.goldenHourResponse.value, into: value)
                case .business:
                    self?.reduce(\.businessResponse.value, into: value)
                case .architecture:
                    self?.reduce(\.architectureResponse.value, into: value)
                }
            }
        }
    }
    
    private func loadImages(type: TopicType, with data: [UnsplashResponse]) {
        repository.requestImage(of: data) {[weak self] value in
            switch type {
            case.goldenHour:
                self?.reduce(\.goldenHourData.value, into: value)
            case .business:
                self?.reduce(\.businessData.value, into: value)
            case .architecture:
                self?.reduce(\.architectureData.value, into: value)
            }
        }
    }
}
