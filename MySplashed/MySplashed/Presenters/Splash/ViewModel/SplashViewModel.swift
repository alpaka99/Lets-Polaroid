//
//  SplashViewModel.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import Foundation

final class SplashViewModel: ViewModel {
    
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input = Input()
    var output = Output()
    
    
    enum Action: String {
        case splashViewAction
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
}
