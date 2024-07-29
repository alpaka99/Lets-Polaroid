//
//  DetailPhotoViewController.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

final class DetailPhotoViewController: BaseViewController<DetailPhotoView, DetailPhotoViewModel> {
    
    weak var delegate: DetailPhotoViewControllerDelegate?
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.photoHeaderView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        viewModel.actionBind(\.selectedImage) {[weak self] imageData in
            if let imageData = imageData {
                self?.baseView.configureNotConnectedData(imageData)
            }
        }
        
        viewModel.actionBind(\.detailPhotoData) {[weak self] value in
            if let value = value {
                self?.baseView.configureDetailData(value)
            }
        }
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backbuttonTapped))
    }
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        viewModel.react(.likeButtonTapped, value: true)
        if let imageData = viewModel(\.selectedImage).value {
            delegate?.likeStatusChanged(of: imageData)
        }
    }
    
    @objc
    private func backbuttonTapped(_ sener: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

protocol DetailPhotoViewControllerDelegate: AnyObject {
    func likeStatusChanged(of data: UnsplashImageData)
}
