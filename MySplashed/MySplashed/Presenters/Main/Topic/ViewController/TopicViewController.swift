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
        
        NetworkManager.shared.sendRequest(ofType: [TopicResponse].self) { _ in
            print("This")
        }
        
        // profile iamge rightBarButton으로 넣기
    }
}
