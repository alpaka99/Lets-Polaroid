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
}
