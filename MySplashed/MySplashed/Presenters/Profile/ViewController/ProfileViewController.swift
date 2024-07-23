//
//  ProfileViewController.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileView, ProfileViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "PROFILE SETTING"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.profileImage.tapGestureRecognizer.addTarget(self, action: #selector(profileImageTapped))
    }
    
    @objc
    func profileImageTapped(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
}
