//
//  ProfileViewModel.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import Foundation

final class ProfileViewModel: ViewModel {
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case profileViewModelAction
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
}
