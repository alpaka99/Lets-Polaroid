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
        
        navigationItem.title = "TOPIC"
    }
}
