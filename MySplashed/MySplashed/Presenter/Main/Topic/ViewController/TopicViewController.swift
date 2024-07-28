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
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        viewModel.bind(\.selectedImage) {[weak self] value in
            if let vc = self {
                let detailViewModel = DetailPhotoViewModel()

                detailViewModel.react(.recieveImageData, value: value)
                
                vc.navigationController?.pushViewController(DetailPhotoViewController(baseView: DetailPhotoView(), viewModel: detailViewModel), animated: true)
            }
        }
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
