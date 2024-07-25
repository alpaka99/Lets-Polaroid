//
//  SplashViewController.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import UIKit

final class SplashViewController: BaseViewController<SplashView, SplashViewModel> {
    override func configureDelegate() {
        super.configureDelegate()
        baseView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    override func configureDataBinding() {
        super.configureDataBinding()
        viewModel.bind(\.isShowOnboarding) {[weak self] _ in
            let profileViewController = ProfileSettingViewController(
                baseView: ProfileSettingView(),
                viewModel: ProfileSettingViewModel()
            )
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @objc
    func startButtonTapped(_ sender: UIButton) {
        viewModel.react(.startButtonTapped, value: true)
    }
}
