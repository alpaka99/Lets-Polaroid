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
        var sortOption: Observable<SearchSortOption> = Observable(.relevant)
        
    }
    
    struct Output: Equatable {
        var searchData: Observable<[UnsplashImageData]> = Observable([])
        var isInitialSearch = Observable(false)
        var selectedImage: Observable<UnsplashImageData?> = Observable(nil)
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    enum Action: String {
        case searchButtonTapped
        case prefetchImage
        case toggleSortOption
        case cellTapped
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
            prefetchImage(value)
        case .toggleSortOption:
            toggleSortOption()
        case .cellTapped:
            cellTapped(value)
        }
    }
    
    func configureBind() {
        bind(\.searchText) {[weak self] value in
            if let vm = self {
                vm.repository.requestSearchImage(
                    value,
                    sortOption: vm(\.sortOption).value
                ) { imageData in
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
                    vm.repository.prefetchImage(
                        vm(\.searchText).value,
                        page: vm(\.currentPage).value,
                        sortOption: vm(\.sortOption).value
                    ) { imageData in
                        vm.prefetchComplete(imageData)
                    }
                }
            }
        }
        
        bind(\.sortOption) { [weak self] value in
            if let vm = self {
                let imageData = vm.repository.returnImageData([], sortOption: vm(\.sortOption).value)
                vm.reduce(\.searchData.value, into: imageData)
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
    private func prefetchImage<T: Equatable>(_ index: T) {
        if self(\.isPrefetching).value == false {
            if let index = index as? Int {
                if index > self(\.searchData).value.count - 4 {
                    let nextPage = self(\.currentPage).value + 1
                    reduce(\.currentPage.value, into: nextPage)
                    reduce(\.isPrefetching.value, into: true)
                }
            }
        }
    }
    
    private func prefetchComplete(_ imageData: [UnsplashImageData]) {
        reduce(\.isPrefetching.value, into: false)
        
        reduce(\.searchData.value, into: imageData)
        
        let newPage = self(\.currentPage).value + 1
        reduce(\.currentPage.value, into: newPage)
    }
    
    private func toggleSortOption() {
        let currentSortOption = self(\.sortOption).value
        let toggledSortOption = currentSortOption.toggled
        
        reduce(\.sortOption.value, into: toggledSortOption)
    }
    
    private func cellTapped<T: Equatable>(_ value: T) {
        if let imageData = value as? UnsplashImageData {
            reduce(\.selectedImage.value, into: imageData)
        }
    }
}
