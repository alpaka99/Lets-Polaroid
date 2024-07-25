//
//  SearchViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class SearchViewModel: ViewModel {
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case searchViewAction
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
    
    func configureBind() {
        
    }
}
