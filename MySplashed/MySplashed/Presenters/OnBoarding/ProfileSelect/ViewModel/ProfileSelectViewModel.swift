//
//  ProfileSelectViewModel.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import Foundation

final class ProfileSelectViewModel: ViewModel {
    struct Input: Equatable {
        var profileImageSelected = Observable(ProfileImage.randomProfile())
    }
    
    struct Output: Equatable {
        var selectedProfileImage = Observable(ProfileImage.randomProfile())
        var profileImages = Observable(ProfileImage.allData)
    }
    
    var input = Input()
    var output = Output()
    
    init() {
        configureBind()
    }
    
    enum Action: String {
        case profileImageSelected
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .profileImageSelected:
            userSelectedProfileImage(value)
        }
    }
    
    func configureBind() {
        actionBind(\.profileImageSelected) {[weak self] profileImage in
            self?.profileImageSelected(profileImage)
        }
    }
    
    private func profileImageSelected(_ profileImage: ProfileImage) {
        reduce(\.selectedProfileImage.value, into: profileImage)
        let profileImageArray = self(\.profileImages).value.map {
            if $0.imageName == profileImage.rawValue {
                return ProfileImageData(imageName: $0.imageName, isSelected: true)
            } else {
                return ProfileImageData(imageName: $0.imageName)
            }
        }
        
        reduce(\.profileImages.value, into: profileImageArray)
    }
    
    private func userSelectedProfileImage<T: Equatable>(_ value: T) {
        if let value = value as? ProfileImage {
            profileImageSelected(value)
        }
    }
}
