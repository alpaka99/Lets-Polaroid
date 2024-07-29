//
//  TopicViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class TopicViewController: BaseViewController<TopicView, TopicViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.react(.topicViewDidLoad, value: true)
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        // profile iamge rightBarButton으로 넣기
        
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.collectionView.delegate = self
    }
    
    
    override func configureDataBinding() {
        super.configureDataBinding()
        
        viewModel.bind(\.goldenHourData) {[weak self] value in
            self?.baseView.updateSnapShot(value, sectionType: .goldenHour)
        }
        
        viewModel.bind(\.businessData) {[weak self] value in
            self?.baseView.updateSnapShot(value, sectionType: .business)
        }
        
        viewModel.bind(\.architectureData) {[weak self] value in
            self?.baseView.updateSnapShot(value, sectionType: .architecture)
        }
        
        viewModel.bind(\.selectedImage) {[weak self] value in
            if let vc = self {
                let detailViewModel = DetailPhotoViewModel()

                detailViewModel.react(.recieveImageData, value: value)
                let detailViewController = DetailPhotoViewController(baseView: DetailPhotoView(), viewModel: detailViewModel)
                
                let navigationController = UINavigationController(rootViewController: detailViewController)
                navigationController.modalPresentationStyle = .fullScreen
                vc.present(navigationController, animated: true)
            }
        }
        
        viewModel.bind(\.userData) {[weak self] userData in
            if let userData = userData, let vc = self {
                let editButtonImage = RoundImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
                editButtonImage.setProfileImage(userData.profileImage)
                editButtonImage.selected()
                editButtonImage.tapGestureRecognizer.addTarget(vc, action: #selector(vc.profileEditButtonTapped))
                let rightBarButtonItem = UIBarButtonItem(customView: editButtonImage)
                
                
                vc.navigationItem.rightBarButtonItem = rightBarButtonItem
                vc.navigationItem.title = "Topic View"
            }
        }
        
        viewModel.bind(\.isMovingToProfileEditView) {[weak self] _ in
            self?.navigationController?.pushViewController(ProfileSettingViewController(baseView: ProfileSettingView(), viewModel: ProfileSettingViewModel(), mode: .edit), animated: true)
        }
    }
    
    @objc
    private func profileEditButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.react(.profileEditButtonTapped, value: true)
    }
}

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = TopicSection.intInit(indexPath.section) {
            let data = baseView.dataSource.snapshot(for: section).items[indexPath.row]
            viewModel.react(.cellTapped, value: data)
        }
    }
}
