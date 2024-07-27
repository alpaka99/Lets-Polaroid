//
//  DetailPhotoViewController.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

final class DetailPhotoViewController: BaseViewController<DetailPhotoView, DetailPhotoViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.photoHeaderView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.actionBind(\.detailPhotoData) {[weak self] value in
            if let value = value {
                self?.baseView.configureData(value)
            }
        }
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton) {
        viewModel.react(.likeButtonTapped, value: true)
    }
}
