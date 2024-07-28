//
//  SearchViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class SearchViewController: BaseViewController<SearchView, SearchViewModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.react(.viewWillAppear, value: true)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "SEARCH VIEW"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.searchBar.delegate = self
        baseView.delegate = self
        baseView.collectionView.prefetchDataSource = self
        baseView.collectionView.delegate = self
        baseView.sortButton.addTarget(self, action: #selector(toggleSort), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        viewModel.bind(\.searchData) {[weak self] value in
            self?.baseView.updateSnapShot(value)
        }
        
        viewModel.bind(\.isInitialSearch) {[weak self] value in
            self?.baseView.moveToTop()
        }
        
        viewModel.bind(\.selectedImage) {[weak self] value in
            if let vc = self {
                let detailViewModel = DetailPhotoViewModel()

                detailViewModel.react(.recieveImageData, value: value)
                
                let detailSearchViewController = DetailPhotoViewController(baseView: DetailPhotoView(), viewModel: detailViewModel)
                
                detailSearchViewController.delegate = vc
                
                vc.navigationController?.pushViewController(detailSearchViewController, animated: true)
            }
        }
    }
    
    @objc
    private func toggleSort(_ sender: UIButton) {
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = baseView.dataSource.snapshot(for: .main).items[indexPath.row]
        viewModel.react(.cellTapped, value: data)
    }
}

extension SearchViewController: SearchViewDelegate {
    func likeButtonTapped(_ index: Int) {
        let imageData = baseView.dataSource.snapshot(for: .main).items[index]
        viewModel.react(.likeButtonTapped, value: imageData)
    }
}

extension SearchViewController: DetailPhotoViewControllerDelegate {
    func likeStatusChanged(of data: UnsplashImageData) {
        viewModel.react(.likeStatusChanged, value: data)
    }
}
