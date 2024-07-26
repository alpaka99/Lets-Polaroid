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
        var isPrefetching = Observable(false)
        var total = Observable(0)
    }
    
    struct Output: Equatable {
        var searchData: Observable<[UnsplashImageData]> = Observable([])
        var isInitialSearch = Observable(false)
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    enum Action: String {
        case searchButtonTapped
        case prefetchImage
    }
    
    let repository = SearchRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .searchButtonTapped:
            searchImage(value)
        case .prefetchImage:
            prefetchImage()
        }
    }
    
    func configureBind() {
        bind(\.searchText) {[weak self] value in
            if let vm = self {
                vm.repository.requestSearchImage(value) { imageData in
                    vm.reduce(\.searchData.value, into: imageData)
                    vm.reduce(\.currentPage.value, into: 1)
                    let toggledValue = !vm(\.isInitialSearch).value
                    self?.reduce(\.isInitialSearch.value, into: toggledValue)
                }
            }
        }
        
        bind(\.isPrefetching) { [weak self] _ in
            if let vm = self {
                if vm(\.isPrefetching).value == true {
                    vm.repository.prefetchImage(vm(\.searchText).value, page: vm(\.currentPage).value, completionHandler: { imageData in
                        print("Prefetch done")
                        vm.prefetchComplete(imageData)
                    })
                }
            }
        }
    }
    
    private func searchImage<T: Equatable>(_ value: T) {
        if let value = value as? String, value != self(\.searchText).value {
            reduce(\.currentPage.value, into: 1)
            reduce(\.searchText.value, into: value)
        }
    }
    
    // prefetch action
    private func prefetchImage() {
        print(#function, ">>>>>>>>>>>>>>>>>>>>>>")
        let nextPage = self(\.currentPage).value + 1
        let isPrefetching = self(\.isPrefetching).value
        if isPrefetching == false {
            reduce(\.currentPage.value, into: nextPage)
            reduce(\.isPrefetching.value, into: true)
        }
    }
    
    private func prefetchComplete(_ imageData: [UnsplashImageData]) {
        reduce(\.isPrefetching.value, into: false)
        
        var newSearchData = self(\.searchData).value
        newSearchData.append(contentsOf: imageData)
        reduce(\.searchData.value, into: newSearchData)
        
        let newPage = self(\.currentPage).value + 1
        reduce(\.currentPage.value, into: newPage)
    }
}
