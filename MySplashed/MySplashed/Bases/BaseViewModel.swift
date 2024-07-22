//
//  BaseViewModel.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

import Foundation


protocol ViewModel<Input, Output>: AnyObject {
    // Input Data Struct
    associatedtype Input
    
    // Output Data Struct
    associatedtype Output
    
    // User Action을 Enum으로 표현
    // 현재 버전에서는 일단 String을 rawValue로 가지는 enum
    associatedtype Action: RawRepresentable where Action.RawValue == String
    
    // callAsFunction의 경우, 정적으로 호출 가능한(statically callable value)의 값을 직접 호출할 수 있게 해줌
//    func callAsFunction<T: Equatable>(_ path: KeyPath<ViewModelState, T>) -> T
    
    // react 메서드의 내부는 switch-case로 구현되어 가독성을 높히고, 명확하게 action에 따른 logic을 실행 할 수 있게 함
    func react<T: Equatable>(_ action: Action, value: T)
    
    //react 메서드를 통해 Input 혹은 Output 데이터의 변형이 일어나는 경우, 이 reduce 메서드를 거쳐서 일어남
    func reduce<T: Equatable>(_ path: WritableKeyPath<ViewModelState, T>, into newValue: T)
}

protocol ViewModelState { }


class BaseViewModel: ViewModel {
    struct Input {
        let input: String = ""
    }
    
    private var input = Input()
    
    struct Output {
        let output: Int = 0
    }
    
    private var output = Output()
    
    enum Action: String {
        case test
    }
    
}

extension BaseViewModel {
    func reduce<T: Equatable>(_ path: WritableKeyPath<ViewModelState, T>, into newValue: T) {
        
    }
    
    func callAsFunction<T: Equatable>(_ path: KeyPath<Input, T>) -> T {
        return self.input[keyPath: path]
    }
    
    func callAsFunction<T>(_ path: KeyPath<Output, T>) -> T where T : Equatable {
        return self.output[keyPath: path]
    }
    
    func react<T: Equatable>(_ action: Action, value: T) {
        
    }
}


/*
 사용법(Usage):
 */
final class TestViewModel: BaseViewModel {
    struct Input {
        let testInput: String = ""
    }
    
    struct Output {
        let testOutput: Int = 123
    }
}
class TestClass {
    let viewModel = BaseViewModel()
    
    
    func test() {
        let input = viewModel(\.input)
        let output = viewModel(\.output)
        
        viewModel.react(.test, value: 123)
    }
}
