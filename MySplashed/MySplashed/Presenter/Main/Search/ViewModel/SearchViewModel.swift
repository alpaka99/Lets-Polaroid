//
//  SearchViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class SearchViewModel: ViewModel {
    struct Input: Equatable {
        var searchText = Observable("")
        var currentPage = Observable(0)
    }
    
    struct Output: Equatable {
        var searchData: Observable<[UnsplashImageData]> = Observable([])
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case searchButtonTapped
    }
    
    let repository = SearchRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .searchButtonTapped:
            searchImage(value)
        }
    }
    
    func configureBind() {
        bind(\.searchText) {[weak self] value in
            self?.repository.requestSearchImage(value) { imageData in
                self?.reduce(\.searchData.value, into: imageData)
            }
        }
    }
    
    private func searchImage<T: Equatable>(_ value: T) {
        if let value = value as? String, value != self(\.searchText).value {
            reduce(\.searchText.value, into: value)
        }
    }
    
    // prefetch action
//    private func preferchImage<T: Equatable>(_ value: T) {
//        if let value = value as? String {
//            
//        }
//    }
}
