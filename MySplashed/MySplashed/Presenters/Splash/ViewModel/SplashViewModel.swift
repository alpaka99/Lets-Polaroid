//
//  SplashViewModel.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import Foundation

final class SplashViewModel: ViewModel {
    struct Input: Equatable {
        var startButtonTapped = Observable(false)
    }
    
    struct Output: Equatable {
        var isShowOnboarding = Observable(false)
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case startButtonTapped
    }
    
    // MARK: 추후에 이 부분이 자동으로 등록되거나, protocol에서 required로 강제될 수 있도록 하기
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        switch action {
        case .startButtonTapped:
            startButtonTapped()
        }
    }
    
    private func startButtonTapped() {
        let toggledValue = !self(\.startButtonTapped).value
        reduce(\.startButtonTapped.value, into: toggledValue)
    }
    
    private func bindStartButtonTapped() {
        self(\.startButtonTapped).bind { [weak self] value in
            self?.reduce(\.isShowOnboarding.value, into: value)
        }
    }
    
    func configureBind() {
        bindStartButtonTapped()
    }
}
