//
//  TopicData.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

struct UnsplashImageData: Equatable, Hashable {
    let unsplashResponse: UnsplashResponse
    let image: UIImage
    let isLiked: Bool = false
}
