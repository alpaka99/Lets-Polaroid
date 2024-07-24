//
//  ProfileSelectViewModel.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import Foundation

final class ProfileSelectViewModel: ViewModel {
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input = Input()
    var output = Output()
    
    init() {
        configureBind()
    }
    
    enum Action: String {
        case profileSelectAction
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
    
    func configureBind() {
        
    }
}
