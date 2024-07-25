//
//  TopicViewModel.swift
//  MySplashed
//
//  Created by user on 7/25/24.
//

import Foundation

final class TopicViewModel: ViewModel {
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case topicViewAction
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
    
    func configureBind() {
        
    }
}
