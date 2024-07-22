//
//  Observable.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

final class Observable<T> {
    var value: T

    var closure: ((T)->Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T)->Void) {
        self.closure = closure
    }
    
    func actionBind(_ closure: @escaping (T)->Void) {
        closure(value)
        self.closure = closure
    }
}
