//
//  SearchSortOption.swift
//  MySplashed
//
//  Created by user on 7/29/24.
//

enum SearchSortOption: String {
    case relevant = "관련순"
    case latest = "최신순"
    
    var toggled: Self {
        switch self {
        case .relevant:
            return .latest
        case .latest:
            return .relevant
        }
    }
}
