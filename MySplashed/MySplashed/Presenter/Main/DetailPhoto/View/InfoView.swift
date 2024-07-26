//
//  InfoView.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class InfoView: BaseView {
    private let infoTitleLabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let test1 = InfoLabel()
    private let test2 = InfoLabel()
    private let test3 = InfoLabel()
    private lazy var infoStack = {[weak self] in
        guard let view = self else { return UIStackView() }
        let stack = UIStackView(arrangedSubviews: [
            view.test1,
            view.test2,
            view.test3
        ])
        stack.axis = .vertical
        
        return stack
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(infoTitleLabel)
        self.addSubview(infoStack)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        infoTitleLabel.snp.makeConstraints { label in
            label.top.leading.equalTo(self.safeAreaLayoutGuide)
        }
        infoStack.snp.makeConstraints { stack in
            stack.top.trailing.equalToSuperview()
        }
        
        self.backgroundColor = .systemBlue
    }
}
