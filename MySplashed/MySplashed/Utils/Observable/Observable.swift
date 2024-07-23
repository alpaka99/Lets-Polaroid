//
//  Observable.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

final class Observable<T: Equatable> {
    var value: T {
        didSet {
            closure?(value)
        }
    }

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

extension Observable: Equatable {
    static func == (lhs: Observable<T>, rhs: Observable<T>) -> Bool {
        return lhs.value == rhs.value
    }
}
