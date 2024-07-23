//
//  BaseViewController.swift
//  MySplashed
//
//  Created by user on 7/22/24.
//

import UIKit

class BaseViewController<V: BaseView, VM: ViewModel>: UIViewController {
    private let baseView: V
    private let viewModel: VM
    
    override func loadView() {
        self.view = baseView
    }
    
    init(baseView: V, viewModel: VM) {
        self.baseView = baseView
        self.viewModel = viewModel
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
