//
//  LikeViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class LikeViewModel: ViewModel {
    struct Input: Equatable {
        var likeViewWillAppear = Observable(false)
    }
    
    struct Output: Equatable {
        var likedImages: Observable<[UnsplashImageData]> = Observable([])
        var selectedImage: Observable<UnsplashImageData?> = Observable(nil)
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case likeViewWillAppear
        case cellTapped
    }
    
    let repository = LikeRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .likeViewWillAppear:
            likeViewWillAppear()
        case .cellTapped:
            cellTapped(value)
        }
    }
    
    func configureBind() {
        bind(\.likeViewWillAppear) { [weak self] _ in
            if let vm = self {
                do {
                    let likedImages = try vm.repository.returnLikedUnsplashImageData()
                    vm.reduce(\.likedImages.value, into: likedImages)
                } catch {
                    print(error) // MARK: Error Handling 하기(Toast Alert)라던가...
                }
            }
        }
    }
    
    private func likeViewWillAppear() {
        let toggledValue = !self(\.likeViewWillAppear).value
        reduce(\.likeViewWillAppear.value, into: toggledValue)
    }
    
    private func cellTapped<T: Equatable>(_ value: T) {
        if let indexPath = value as? IndexPath {
            let selectedImage = self(\.likedImages).value[indexPath.row]
            reduce(\.selectedImage.value, into: selectedImage)
        }
    }
}
