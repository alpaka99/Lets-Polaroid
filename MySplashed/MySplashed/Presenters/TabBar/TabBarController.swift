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
    case random
    case search
    case like
    
    var viewController: UIViewController {
        switch self {
        case .topic:
            return SplashViewController(baseView: SplashView(), viewModel: SplashViewModel())
        case .random:
            return SplashViewController(baseView: SplashView(), viewModel: SplashViewModel())
        case .search:
            return SplashViewController(baseView: SplashView(), viewModel: SplashViewModel())
        case .like:
            return SplashViewController(baseView: SplashView(), viewModel: SplashViewModel())
        }
    }
    
    var tabBarItem: TabBarItem {
        switch self {
        case .topic:
            return TabBarItem(iamgeName: "tab_trend", title: self.rawValue)
        case .random:
            return TabBarItem(iamgeName: "tab_random", title: self.rawValue)
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
