//
//  UIViewController+.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

extension UIViewController {
    func setNewViewController(nextViewController: UIViewController, isNavigation: Bool) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        var newRootViewController: UIViewController
        if isNavigation {
            newRootViewController = UINavigationController(rootViewController: nextViewController)
        } else {
            newRootViewController = nextViewController
        }
        
        sceneDelegate?.window?.rootViewController = newRootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension UIViewController {
    func showAlert(alertData: [AlertData]) {
        let ac = UIAlertController(title: "계정 삭제", message: "MySplashed 계정을 삭제하실건가요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        ac.addAction(cancelAction)
        alertData.forEach { data in
            let alertAction = UIAlertAction(title: data.title, style: data.style) { _ in
                data.closure()
            }
            ac.addAction(alertAction)
        }
        
        self.present(ac, animated: true)
    }
}
