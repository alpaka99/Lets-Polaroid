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
        var toastMessage = Observable("")
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    enum Action: String {
        case viewWillAppear
        case searchButtonTapped
        case prefetchImage
        case toggleSortOption
        case cellTapped
        case likeButtonTapped
        case likeStatusChanged
    }
    
    private let repository = SearchRepository()
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .viewWillAppear:
            viewWillAppearAction()
        case .searchButtonTapped:
            searchImage(value)
        case .prefetchImage:
            prefetchImage(value)
        case .toggleSortOption:
            toggleSortOption()
        case .cellTapped:
            cellTapped(value)
        case .likeButtonTapped:
            likeButtonTapped(value)
        case .likeStatusChanged:
            changeLikeStatus(of: value)
        }
    }
    
    func configureBind() {
        bind(\.searchText) {[weak self] value in
            if let vm = self {
                vm.repository.requestSearchImage(
                    value,
                    sortOption: vm(\.sortOption).value
                ) { imageResponse in
                    
                    switch imageResponse {
                    case .success(let imageData):
                        vm.reduce(\.searchData.value, into: imageData)
                        vm.reduce(\.currentPage.value, into: 1)
                        let toggledValue = !vm(\.isInitialSearch).value
                        self?.reduce(\.isInitialSearch.value, into: toggledValue)
                    case .failure:
                        self?.reduce(\.toastMessage.value, into: "검색에 실패했어요 ㅠㅠ")
                    }
                    
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
                    ) { imageDataResponse in
                        switch imageDataResponse {
                        case .success(let imageData):
                            vm.prefetchComplete(imageData)
                        case .failure:
                            vm.reduce(\.toastMessage.value, into: "미리 불러오기 실패 ㅠㅠ")
                        }
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
    
    private func likeButtonTapped<T: Equatable>(_ value: T) {
        if let imageData = value as? UnsplashImageData {
            do {
                try repository.deleteDataFromLikedImage(imageData, sortOption: self(\.sortOption).value)
                changeLikeStatus(of: imageData)
            } catch {
                reduce(\.toastMessage.value, into: "좋아요 삭제 기능 에러")
            }
        }
    }
    
    private func changeLikeStatus<T: Equatable>(of data: T) {
        if let imageData = data as? UnsplashImageData {
            let changedData = repository.changeLikeStatus(of: imageData, sortOption: self(\.sortOption).value)
            reduce(\.searchData.value, into: changedData)
        }
    }
    
    private func viewWillAppearAction() {
        repository.loadLikedImage()
        let imageData = repository.reloadImageData(sortOption: self(\.sortOption).value)
        reduce(\.searchData.value, into: imageData)
    }
}
