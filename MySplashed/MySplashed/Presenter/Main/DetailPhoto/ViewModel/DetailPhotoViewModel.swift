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
        var detailPhotoData: Observable<DetailPhotoModel?> = Observable(nil)
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
            if let vm = self, let photographer = value?.unsplashResponse.photographer {
                vm.repository.requestImage(of: photographer) { photographerData in
                    vm.reduce(\.photographerData.value, into: photographerData)
                }
            }
        }
        
        bind(\.photographerData) { [weak self] value in
            if let vm = self {
                if let imageData = vm(\.selectedImage).value, let photographerData = vm(\.photographerData).value {
                    
                    let detailPhotoData = DetailPhotoModel(photographerData: photographerData, imageData: imageData)
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
            reduce(\.selectedImage.value, into: value)
        }
    }
    
    private func likeButtonTapped() {
        let toggledValue = !self(\.likeButtonTapped).value
        reduce(\.likeButtonTapped.value, into: toggledValue)
    }
}

