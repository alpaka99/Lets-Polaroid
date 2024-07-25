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
}
