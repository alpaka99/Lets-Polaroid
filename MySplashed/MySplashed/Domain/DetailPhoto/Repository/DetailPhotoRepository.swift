//
//  DetailPhotoRepository.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

import Kingfisher
final class DetailPhotoRepository {
    func requestImage(of photographer: Photographer, completionHandler: @escaping (PhotographerData)->Void) {
        if let imageURL = photographer.profileImageURL["large"], let url = URL(string: imageURL) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let image):
                    let userData = PhotographerData(
                        photographer: photographer,
                        profileImage: image.image
                    )
                    completionHandler(userData)
                case .failure(let error):
                    print("KingFisher ImageFetch Error", error)
                }
            }
        }
    }
}
