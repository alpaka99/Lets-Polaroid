//
//  SearchRepository.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

final class SearchRepository {
    func requestSearchImage(_ searchText: String) {
        print(searchText)
        NetworkManager.shared.sendRequest(.search(searchText: searchText), ofType: SearchResponse.self) { searchResponse in
            print(searchResponse.results.count)
        }
    }
}
