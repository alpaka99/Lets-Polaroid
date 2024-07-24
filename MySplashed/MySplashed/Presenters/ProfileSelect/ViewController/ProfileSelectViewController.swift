//
//  ProfileSelectViewController.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

final class ProfileSelectViewController: BaseViewController<ProfileSelectView, ProfileSelectViewModel> {
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "EDIT PROFILE"
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.actionBind(\.selectedProfileImage) {[weak self] profileImage in
            self?.baseView.selectedProfileImage.setProfileImage(profileImage)
        }
        
        viewModel.actionBind(\.profileImages) { [weak self] value in
            self?.baseView.updateSnapShot(with: value)
        }
    }
}
