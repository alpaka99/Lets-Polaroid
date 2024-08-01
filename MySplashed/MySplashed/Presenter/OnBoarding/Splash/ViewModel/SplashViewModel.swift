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
        var isShowingStartButton = Observable(false)
        var isShowOnboarding = Observable(false)
        var isShowingMain = Observable(false)
        var userData: Observable<UserData?> = Observable(nil)
        var toastMessage = Observable("")
    }
    
    lazy var input = Input()
    lazy var output = Output()
    
    enum Action: String {
        case startButtonTapped
    }
    
    private let repository = SplashRepository()
    
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
    
    func configureBind() {
        bind(\.startButtonTapped) { [weak self] value in
            self?.loadUserData()
        }

        
        bind(\.userData) {[weak self] value in
            guard let vm = self else { return }
            if value == nil {
                let toggledValue = !vm(\.isShowOnboarding).value
                vm.reduce(\.isShowOnboarding.value, into: toggledValue)
            } else {
                let toggledValue = !vm(\.isShowingMain).value
                vm.reduce(\.isShowingMain.value, into: toggledValue)
            }
        }
    }
    
    private func startButtonTapped() {
        let toggledValue = !self(\.startButtonTapped).value
        reduce(\.startButtonTapped.value, into: toggledValue)
    }
    
    
    private func loadUserData() {
        do {
            let userData = try repository.loadUserData()
            reduce(\.userData.value, into: userData)
        } catch {
            reduce(\.toastMessage.value, into: "사용자 데이터를 로딩할 수 없어요")
        }
    }
}
