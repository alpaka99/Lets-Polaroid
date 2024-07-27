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
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case likeViewWillAppear
    }
    
    let repository = LikeRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .likeViewWillAppear:
            likeViewWillAppear()
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
}
