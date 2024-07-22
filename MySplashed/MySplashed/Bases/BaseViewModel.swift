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
        let input = Observable("")
    }
    
    private var input = Input()
    
    struct Output {
        let output = Observable(1)
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
    
    private var input = Input()
    
    struct Output {
        let testOutput: Int = 123
    }
    
    private var output = Output()
}
class TestClass {
    let viewModel = TestViewModel()
    
    
    func test() {
        let input = viewModel(\.input).getValue()
        /*
        extension이 BaseViewModel에선언되어 있어서 baseViewModel의 keyPath만 읽어오는 문제
         그렇다고 input과 output을 protocol에 명시해놓으면 접근을 할 수 있게 되어버리는데...
         private(set)으로 읽기는 가능하지만 쓰기는 못하게 해야하려나...
         더불어서 reduce() 메서드도 접근 가능하네 흠... react만 접근 가능해져야하는데 말이지...
         근데 bind는 그냥 가능하게 하고 싶으니까 일단 private(set)으로 해놓고, reduce는 BaseViewModel의 메서드로 구현해놔야할듯하네요?
         */
        let output = viewModel(\.output).getValue()
        
        viewModel.react(.test, value: 123)
    }
}
