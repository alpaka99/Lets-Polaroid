//
//  BaseViewController.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

import UIKit

class BaseViewController<T: BaseView>: UIViewController {
    private let baseView: T
    
    init(baseView: T) {
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureDelegate()
        configureDataBinding()
    }
    
    func configureNavigationItem() { }
    func configureDelegate() { }
    func configureDataBinding() { }
}
