//
//  TabBarController.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = TabBarComponents.allCases.map {
            $0.navigationController
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}

enum TabBarComponents: String, CaseIterable {
    case topic
//    case random
    case search
    case like
    
    var viewController: UIViewController {
        switch self {
        case .topic:
            return TopicViewController(
                baseView: TopicView(),
                viewModel: TopicViewModel()
            )
        case .search:
            return SearchPhotoViewController(
                baseView: SearchPhotoView(),
                viewModel: SearchPhotoViewModel()
            )
        case .like:
            return LikeViewController(
                baseView: LikeView(),
                viewModel: LikeViewModel()
            )
        }
    }
    
    var tabBarItem: TabBarItem {
        switch self {
        case .topic:
            return TabBarItem(iamgeName: "tab_trend", title: self.rawValue)
//        case .random:
//            return TabBarItem(iamgeName: "tab_random", title: self.rawValue)
        case .search:
            return TabBarItem(iamgeName: "tab_search", title: self.rawValue)
        case .like:
            return TabBarItem(iamgeName: "tab_like", title: self.rawValue)
        }
    }
    
    var navigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: self.viewController)
        navigationController.tabBarItem.image = UIImage(named: self.tabBarItem.iamgeName)
        return navigationController
    }
}


struct TabBarItem {
    let iamgeName: String
    let title: String
}
