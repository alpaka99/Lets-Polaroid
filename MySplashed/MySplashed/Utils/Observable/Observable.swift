//
//  Observable.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

final class Observable<T> {
    private var value: T

    private var closure: ((T)->Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func setValue(_ value: T) {
        self.value = value
    }
    
    func getValue() -> T {
        return self.value
    }
    
    func bind(_ closure: @escaping (T)->Void) {
        self.closure = closure
    }
    
    func actionBind(_ closure: @escaping (T)->Void) {
        closure(value)
        self.closure = closure
    }
}
