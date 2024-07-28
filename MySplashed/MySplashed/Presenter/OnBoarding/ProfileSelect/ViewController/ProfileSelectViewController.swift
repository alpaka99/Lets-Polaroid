//
//  ProfileSelectViewController.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

final class ProfileSelectViewController: BaseViewController<ProfileSelectView, ProfileSelectViewModel> {
    weak var delegate: ProfileSelectViewControllerDelegate?
    
    convenience init(baseView: ProfileSelectView, viewModel: ProfileSelectViewModel, profileImage: ProfileImage) {
        self.init(baseView: baseView, viewModel: viewModel)
        viewModel.react(.profileImageSelected, value: profileImage)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "EDIT PROFILE"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.profileCollectionView.delegate = self
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

extension ProfileSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = baseView.dataSource.snapshot(for: .main).items[indexPath.row]
        if let profileImage = ProfileImage(rawValue: data.imageName) {
            viewModel.react(.profileImageSelected, value: profileImage)
        }
    }
}


protocol ProfileSelectViewControllerDelegate: AnyObject {
    func profileImageSelected(_ profileImage: ProfileImage)
}
