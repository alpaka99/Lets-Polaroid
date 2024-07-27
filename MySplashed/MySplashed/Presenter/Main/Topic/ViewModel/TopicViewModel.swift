//
//  TopicViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class TopicViewModel: ViewModel {
    struct Input: Equatable {
        var topicViewDidLoad = Observable(false)
        var topicViewWillAppear = Observable(false)
        var goldenHourResponse: Observable<[UnsplashResponse]> = Observable([])
        var businessResponse: Observable<[UnsplashResponse]> = Observable([])
        var architectureResponse: Observable<[UnsplashResponse]> = Observable([])
        var tappedIndex = Observable(IndexPath(row: 0, section: 0))
    }
    
    struct Output: Equatable {
        var goldenHourData: Observable<[UnsplashImageData]> = Observable([])
        var businessData: Observable<[UnsplashImageData]> = Observable([])
        var architectureData: Observable<[UnsplashImageData]> = Observable([])
        var selectedImage: Observable<UnsplashImageData?> = Observable(nil)
    }
    
    var input = Input()
    var output = Output()
    
    let repository = TopicRepository()
    
    enum Action: String {
        case topicViewDidLoad
        case topicViewWillAppear
        case loadTopics
        case loadLikedImages
        case cellTapped
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .topicViewDidLoad:
            topicViewDidLoad()
        case .topicViewWillAppear:
            topicViewWillAppear()
        case .loadTopics:
            loadTopics()
        case .loadLikedImages:
            loadLikedImages()
        case .cellTapped:
            cellTapped(value)
        }
    }
    
    func configureBind() {
        bind(\.topicViewDidLoad) {[weak self] _ in
            // topic view appearing event
            self?.react(.loadTopics, value: true)
        }
        
        bind(\.topicViewWillAppear) { [weak self] _ in
            self?.react(.loadLikedImages, value: true)
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
    
    private func topicViewDidLoad() {
        let toggledValue = !self(\.topicViewDidLoad).value
        reduce(\.topicViewDidLoad.value, into: toggledValue)
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
    
    private func cellTapped<T: Equatable>(_ value: T) {
        if let indexPath = value as? IndexPath, let topicType = TopicType.sectionNumberInit(indexPath.section) {
            var selectedImage: UnsplashImageData
            switch topicType {
            case .goldenHour:
                selectedImage = self(\.goldenHourData).value[indexPath.row]
            case .business:
                selectedImage = self(\.businessData).value[indexPath.row]
            case .architecture:
                selectedImage = self(\.architectureData).value[indexPath.row]
            }
            selectedImage = repository.checkImageIsLiked(selectedImage)
            
            reduce(\.selectedImage.value, into: selectedImage)
        }
    }
    
    private func topicViewWillAppear() {
        let toggledValue = !self(\.topicViewWillAppear).value
        reduce(\.topicViewWillAppear.value, into: toggledValue)
    }
    
    private func loadLikedImages() {
        repository.loadLikedImages()
    }
}
