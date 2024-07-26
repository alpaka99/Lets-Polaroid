//
//  SearchViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class SearchViewController: BaseViewController<SearchView, SearchViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "SEARCH VIEW"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.searchBar.delegate = self
        baseView.collectionView.prefetchDataSource = self
        baseView.sortButton.addTarget(self, action: #selector(toggleSort), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        viewModel.bind(\.searchData) {[weak self] value in
            self?.baseView.updateSnapShot(value)
        }
        
        viewModel.bind(\.isInitialSearch) {[weak self] value in
            self?.baseView.moveToTop()
        }
    }
    
    @objc
    func toggleSort(_ sender: UIButton) {
        viewModel.react(.toggleSortOption, value: true)
        baseView.toggleSortOption(viewModel(\.sortOption).value.toggled)
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            viewModel.react(.searchButtonTapped, value: searchText)
        }
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let index = indexPaths.last?.row {
            viewModel.react(.prefetchImage, value: index)
        }
    }
}
