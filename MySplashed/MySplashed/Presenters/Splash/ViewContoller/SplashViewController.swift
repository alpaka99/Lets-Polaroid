//
//  SplashViewController.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import UIKit

final class SplashViewController: BaseViewController<SplashView, SplashViewModel> {
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "SplashView"
    }
}
