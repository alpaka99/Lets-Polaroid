//
//  LikeViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class LikeViewController: BaseViewController<LikeView, LikeViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "LIKE VIEW"
    }
}
