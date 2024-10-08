//
//  ViewModel.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import Foundation


protocol ViewModel<Input, Output>: AnyObject {
    associatedtype Input: Equatable // Input Data Struct
    associatedtype Output: Equatable // Output Data Struct
    
    var input: Input { get set }
    var output: Output { get set }
    
    // User Action을 Enum으로 표현
    // 현재 버전에서는 일단 String을 rawValue로 가지는 enum,
    // 그리고 associatedValue를 받지 않고, value로 따로 받음
    // TODO: wrapping한 enum 타입이 associatedValue를 받은 다음에 한번 변환하면 되는거 아닐까?
    associatedtype Action: RawRepresentable where Action.RawValue == String
    
    // react 메서드의 내부는 switch-case로 구현되어 가독성을 높히고, 명확하게 action에 따른 logic을 실행 할 수 있게 함
    func react<U: Equatable>(_ action: Action, value: U)
    
    func configureBind()
}

extension ViewModel {
    // callAsFunction의 경우, 정적으로 호출 가능한(statically callable value)의 값을 직접 호출할 수 있게 해줌
    // MARK: 추후에 @dynamicMemberLookUp을 통해 function syntax가 아닌, dot syntax로 바꿔줄 수 있을것 같음
    func callAsFunction<T: Equatable>(_ keyPath: KeyPath<Input, T>) -> T {
        let value = self.input[keyPath: keyPath]
        return value
    }
    
    func callAsFunction<T: Equatable>(_ keyPath: KeyPath<Output, T>) -> T {
        return self.output[keyPath: keyPath]
    }
    
    //react 메서드를 통해 Input 혹은 Output 데이터의 변형이 일어나는 경우, 이 reduce 메서드들을 거쳐서 일어남
    
    @discardableResult
    func reduce<T: Equatable, U: Equatable>(
        _ keyPath: WritableKeyPath<Input, T>,
        into newValue: U) -> Bool
    {
        if let convertedValue = newValue as? T {
            self.input[keyPath: keyPath] = convertedValue
            return true
        }
        print("Failed", keyPath)
        return false
    }
    
    @discardableResult
    func reduce<T: Equatable, U: Equatable>(
        _ keyPath: WritableKeyPath<Output, T>,
        into newValue: U) -> Bool
    {
        if let convertedValue = newValue as? T {
            self.output[keyPath: keyPath] = convertedValue
            return true
        }
        print("Failed", keyPath)
        return false
    }
    
    func bind<T: Equatable>(_ keyPath: WritableKeyPath<Input, Observable<T>>, closure: @escaping (T)->Void) {
        self(keyPath).bind(closure)
    }
    
    func bind<T: Equatable>(_ keyPath: WritableKeyPath<Output, Observable<T>>, closure: @escaping (T)->Void) {
        self(keyPath).bind(closure)
    }
    
    func actionBind<T: Equatable>(_ keyPath: WritableKeyPath<Input, Observable<T>>, closure: @escaping (T)->Void) {
        self(keyPath).actionBind(closure)
    }
    
    func actionBind<T: Equatable>(_ keyPath: WritableKeyPath<Output, Observable<T>>, closure: @escaping (T)->Void) {
        self(keyPath).actionBind(closure)
    }
}



/*
    사용법(Sample Usage)
 */
final class BasicViewModel: ViewModel {
    struct Input: Equatable {
        let input = Observable("")
    }
    
    struct Output: Equatable {
        let output = Observable(1)
    }
    
    var input = Input()
    var output = Output()
    
    enum Action: String {
        case basicAction
    }
    
    func react<T>(_ action: Action, value: T) where T : Equatable {
        switch action {
        case .basicAction:
            reduce(\.input.value, into: "qwer")
        }
    }
    
    func configureBind() { }
}


class TestClass {
    let viewModel = BasicViewModel()
    
    func test() {
        viewModel.react(.basicAction, value: "123")
        viewModel(\.input).bind { _ in
            // bind closure
        }
    }
}

/*
extension이 BaseViewModel에선언되어 있어서 baseViewModel의 keyPath만 읽어오는 문제
 그렇다고 input과 output을 protocol에 명시해놓으면 접근을 할 수 있게 되어버리는데...
 private(set)으로 읽기는 가능하지만 쓰기는 못하게 해야하려나...
 더불어서 reduce() 메서드도 접근 가능하네 흠... react만 접근 가능해져야하는데 말이지...
 근데 bind는 그냥 가능하게 하고 싶으니까 일단 private(set)으로 해놓고, reduce는 BaseViewModel의 메서드로 구현해놔야할듯하네요?
 -> private(set)으로 구현하면 WritableKeyPath가 아닌, 그냥 KeyPath 타입으로 추론되서 값을 가져오기는 가능한데 값을 넣는 reduce메서드를 구현할 수 없음 흠...
 */


// MARK: WritableKeyPath Problem
/*
 https://sarunw.com/posts/what-is-keypath-in-swift/
 여기서 보면
 - root가 read-only일 경우(let이나 get의 subscript만 있을 경우) -> KeyPath로 infered됨
 - struct나 enum처럼 valueType의 root인 경우, writableKeyPath가 infered됨
 - Obsevable의 value가 private(set)이어서 그랬네... 잠만 그러면 private 처리를 어떻게 해야하나 ㅠㅠ
 */
