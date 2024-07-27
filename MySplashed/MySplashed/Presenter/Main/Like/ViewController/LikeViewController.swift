//
//  LikeViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class LikeViewController: BaseViewController<LikeView, LikeViewModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.react(.likeViewWillAppear, value: true)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.bind(\.likedImages) {[weak self] value in
            self?.baseView.updateSnapShot(value)
        }
        
        viewModel.bind(\.selectedImage) {[weak self] value in
            let detailViewModel = DetailPhotoViewModel()
            detailViewModel.react(.recieveImageData, value: value)
            let detailViewController = DetailPhotoViewController(baseView: DetailPhotoView(), viewModel: detailViewModel)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "LIKE VIEW"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.collectionView.delegate = self
        baseView.sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func sortButtonTapped(_ sender: UIButton) {
        viewModel.react(.toggleSortOption, value: true)
        baseView.toggleSortOption(viewModel(\.sortOption).value.toggled)
    }
}

extension LikeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.react(.cellTapped, value: indexPath)
    }
}
