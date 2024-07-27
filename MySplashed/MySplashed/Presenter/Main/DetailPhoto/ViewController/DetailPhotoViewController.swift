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
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.actionBind(\.detailPhotoData) {[weak self] value in
            if let value = value {
                self?.baseView.configureData(value)
            }
        }
    }
}
