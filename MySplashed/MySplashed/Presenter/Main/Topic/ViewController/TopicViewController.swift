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
        viewModel.react(.topicViewWillAppear, value: true)
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
        
        viewModel.bind(\.loadDetailView) {[weak self] _ in
            self?.navigationController?.pushViewController(DetailPhotoViewController(baseView: DetailPhotoView(), viewModel: DetailPhotoViewModel()), animated: true)
        }
    }
}

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.react(.cellTapped, value: true)
    }
}
