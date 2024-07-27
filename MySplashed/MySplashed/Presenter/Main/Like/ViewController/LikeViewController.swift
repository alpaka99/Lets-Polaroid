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
            print(value)
            self?.baseView.updateSnapShot(value)
        }
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "LIKE VIEW"
    }
}
