//
//  DetailPhotoViewController.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import CLToaster

final class DetailPhotoViewController: BaseViewController<DetailPhotoView, DetailPhotoViewModel> {
    
    weak var delegate: DetailPhotoViewControllerDelegate?
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.photoHeaderView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        viewModel.actionBind(\.unconnectedSelectedImage) {[weak self] imageData in
            if let imageData = imageData {
                self?.baseView.configureNotConnectedData(imageData)
            }
        }
        
        viewModel.bind(\.detailPhotoData) {[weak self] value in
            if let value = value {
                self?.baseView.configureDetailData(value)
            }
        }
        
        viewModel.bind(\.toastMessage) {[weak self] value in
            guard let vc = self else { return }
            let toastStyle = CLToastStyle(title: value)
            CLToast(with: toastStyle, section: .top)
                .present(in: vc.baseView)
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
