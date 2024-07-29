//
//  DetailPhotoViewModel.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

final class DetailPhotoViewModel: ViewModel {
    struct Input: Equatable {
        var selectedImage: Observable<UnsplashImageData?> = Observable(nil)
        var likeButtonTapped = Observable(false)
    }
    
    struct Output: Equatable {
        var photographerData: Observable<PhotographerData?> = Observable(nil)
        var statisticsData: Observable<StatisticsData?> = Observable(nil)
        var detailPhotoData: Observable<DetailPhotoModel?> = Observable(nil)
        var unconnectedSelectedImage: Observable<UnsplashImageData?> = Observable(nil)
        var toastMessage = Observable("")
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    enum Action: String {
        case recieveImageData
        case likeButtonTapped
    }
    
    private let repository = DetailPhotoRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .recieveImageData:
            receiveImageData(value)
        case .likeButtonTapped:
            likeButtonTapped()
        }
    }
    
    func configureBind() {
        bind(\.selectedImage) {[weak self] value in
            if let vm = self, let imageData = value {
                if let photographerData = vm(\.photographerData).value, let statisticsData = vm(\.statisticsData).value {
                    let detailPhotoData = DetailPhotoModel(photographerData: photographerData, imageData: imageData, statisticsData: statisticsData)
                    vm.reduce(\.detailPhotoData.value, into: detailPhotoData)
                } else {
                    vm.reduce(\.unconnectedSelectedImage.value, into: imageData)
                    
                    self?.asyncRequestPhotographerData(imageData)
                    self?.asyncRequestStatisticsData(imageData)
                }
            }
        }
        
        bind(\.photographerData) { [weak self] value in
            if let vm = self {
                if let imageData = vm(\.selectedImage).value, let photographerData = vm(\.photographerData).value, let statisticsData = vm(\.statisticsData).value {
                    let detailPhotoData = DetailPhotoModel(
                        photographerData: photographerData,
                        imageData: imageData,
                        statisticsData: statisticsData
                    )
                    vm.reduce(\.detailPhotoData.value, into: detailPhotoData)
                }
            }
        }
        
        bind(\.statisticsData) { [weak self] value in
            if let vm = self {
                if let imageData = vm(\.selectedImage).value, let photographerData = vm(\.photographerData).value, let statisticsData = vm(\.statisticsData).value {
                    let detailPhotoData = DetailPhotoModel(
                        photographerData: photographerData,
                        imageData: imageData,
                        statisticsData: statisticsData
                    )
                    vm.reduce(\.detailPhotoData.value, into: detailPhotoData)
                }
            }
        }
        
        bind(\.likeButtonTapped) { [weak self] value in
            if let vm = self {
                if let data = vm(\.selectedImage).value {
                    let toggledData = vm.repository.toggleDataLike(data)
                    vm.reduce(\.selectedImage.value, into: toggledData)
                }
            }
        }
    }
    
    private func receiveImageData<T: Equatable>(_ value: T) {
        if let value = value as? UnsplashImageData {
            let likeCheckedData = repository.checkDataLike(value)
            reduce(\.selectedImage.value, into: likeCheckedData)
        }
    }
    
    private func likeButtonTapped() {
        let toggledValue = !self(\.likeButtonTapped).value
        reduce(\.likeButtonTapped.value, into: toggledValue)
    }
    
    private func asyncRequestPhotographerData(_ imageData: UnsplashImageData) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.repository.requestImage(of: imageData.unsplashResponse.photographer) { photographerResponse in
                switch photographerResponse {
                case .success(let photographerData):
                    DispatchQueue.main.async {
                        self?.reduce(\.photographerData.value, into: photographerData)
                    }
                case .failure:
                    self?.reduce(\.toastMessage.value, into: "사진작가 정보 불러오기 실패")
                }
                
            }
        }
    }
    
    private func asyncRequestStatisticsData(_ imageData: UnsplashImageData) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            self?.repository.requestStatisticsData(with: imageData) { statisticsResponse in
                switch statisticsResponse {
                case .success(let value):
                    DispatchQueue.main.async {
                        self?.reduce(\.statisticsData.value, into: value)
                    }
                case .failure(let error):
                    self?.reduce(\.toastMessage.value, into: "사진 통계 정보 불러오기 실패")
                }
            }
        }
    }
}

