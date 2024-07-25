//
//  TopicViewController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class TopicViewController: BaseViewController<TopicView, TopicViewModel> {
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        // profile iamge rightBarButton으로 넣기
    }
    
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        viewModel.react(.topicViewWillAppear, value: true)
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
    }
}
