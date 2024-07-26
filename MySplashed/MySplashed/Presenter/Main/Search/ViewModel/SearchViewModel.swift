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
    }
    
    struct Output: Equatable {
        
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
            self?.repository.requestSearchImage(value)
        }
    }
    
    private func searchImage<T: Equatable>(_ value: T) {
        if let value = value as? String {
            reduce(\.searchText.value, into: value)
        }
    }
}
