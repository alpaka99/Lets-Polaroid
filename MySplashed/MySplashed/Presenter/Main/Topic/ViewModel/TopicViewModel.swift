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
        var toastMessage = Observable("")
    }
    
    struct Output: Equatable {
        var goldenHourData: Observable<[UnsplashImageData]> = Observable([])
        var businessData: Observable<[UnsplashImageData]> = Observable([])
        var architectureData: Observable<[UnsplashImageData]> = Observable([])
        var selectedImage: Observable<UnsplashImageData?> = Observable(nil)
        var userData: Observable<UserData?> = Observable(nil)
        var isMovingToProfileEditView = Observable(false)
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    private let repository = TopicRepository()
    
    enum Action: String {
        case topicViewDidLoad
        case loadUserData
        case loadTopics
        case loadLikedImages
        case cellTapped
        case profileEditButtonTapped
        case showToastMessage
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .topicViewDidLoad:
            topicViewDidLoad()
        case .loadUserData:
            loadUserData()
        case .loadTopics:
            loadTopics()
        case .loadLikedImages:
            loadLikedImages()
        case .cellTapped:
            cellTapped(value)
        case .profileEditButtonTapped:
            profileEditButtonTapped()
        case .showToastMessage:
            showToastMessage(value)
        }
    }
    
    func configureBind() {
        bind(\.topicViewDidLoad) {[weak self] _ in
            // topic view appearing event
            self?.react(.loadUserData, value: true)
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
    
    private func loadUserData() {
        do {
            let userData = try repository.readAllUserData()
            reduce(\.userData.value, into: userData)
        } catch {
            reduce(\.toastMessage.value, into: "사용자 데이터를 불러오는 과정에서 오류가 발생하였습니다!")
        }
    }
    
    private func loadTopics() {
        TopicType.allCases.forEach {[weak self] topic in
            self?.repository.requestTopic(of: topic) { topicResponse in
                switch topicResponse {
                case .success(let value):
                    switch topic {
                    case .goldenHour:
                        self?.reduce(\.goldenHourResponse.value, into: value)
                    case .business:
                        self?.reduce(\.businessResponse.value, into: value)
                    case .architecture:
                        self?.reduce(\.architectureResponse.value, into: value)
                    }
                case .failure:
                    self?.reduce(\.toastMessage.value, into: "토픽 로딩 실패ㅠㅠ")
                }
            }
        }
    }
    
    private func loadImages(type: TopicType, with data: [UnsplashResponse]) {
        repository.requestImage(of: data) {[weak self] imageResponse in
            switch imageResponse {
            case .success(let value):
                switch type {
                case.goldenHour:
                    self?.reduce(\.goldenHourData.value, into: value)
                case .business:
                    self?.reduce(\.businessData.value, into: value)
                case .architecture:
                    self?.reduce(\.architectureData.value, into: value)
                }
            case .failure:
                self?.reduce(\.toastMessage.value, into: "토픽 이미지 로딩 실패")
            }
        }
    }
    
    private func cellTapped<T: Equatable>(_ value: T) {
        if let selectedImage = value as? UnsplashImageData {
            let newSelectedImage = repository.checkImageIsLiked(selectedImage)
            
            reduce(\.selectedImage.value, into: newSelectedImage)
        }
    }
    
    private func loadLikedImages() {
        repository.loadLikedImages()
    }
    
    private func profileEditButtonTapped() {
        let toggledData = !self(\.isMovingToProfileEditView).value
        reduce(\.isMovingToProfileEditView.value, into: toggledData)
    }
    
    private func showToastMessage<T: Equatable>(_ value: T) {
        if let value = value as? String {
            reduce(\.toastMessage.value, into: value)
        }
    }
}
