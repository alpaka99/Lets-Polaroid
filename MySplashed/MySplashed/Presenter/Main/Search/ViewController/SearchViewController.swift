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
    }
    
    override func configureDataBinding() {
        viewModel.bind(\.searchData) {[weak self] value in
            self?.baseView.updateSnapShot(value)
        }
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
        if let index = indexPaths.last?.row, index > 15 {
            print(index)
        }
    }
}
