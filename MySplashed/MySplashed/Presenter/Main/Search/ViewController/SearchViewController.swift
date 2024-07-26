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
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            print(#function, searchText)
            viewModel.react(.searchButtonTapped, value: searchText)
        }
    }
}
