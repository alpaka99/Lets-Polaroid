//
//  DetailPhotoViewModel.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import Foundation

final class DetailPhotoViewModel: ViewModel {
    struct Input: Equatable {
        
    }
    
    struct Output: Equatable {
        
    }
    
    var input: Input = Input()
    var output: Output = Output()
    
    enum Action: String {
        case detailPhotoAction
    }
    
    init() {
        configureBind()
    }
    
    func react<U>(_ action: Action, value: U) where U : Equatable {
        
    }
    
    func configureBind() {
        
    }
}
