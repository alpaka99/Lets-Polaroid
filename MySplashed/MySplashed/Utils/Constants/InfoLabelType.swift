//
//  InfoLabelType.swift
//  MySplashed
//
//  Created by user on 7/29/24.
//

enum InfoLabelType: CaseIterable {
    case size
    case views
    case downloads
    
    var title: String {
        switch self {
        case .size:
            return "크기"
        case .views:
            return "조회수"
        case .downloads:
            return "다운로드"
        }
    }
}
