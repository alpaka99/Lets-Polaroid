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
    
    private lazy var infoStack = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
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
    
    func configureStackView(_ data: DetailPhotoModel) {
        infoStack.arrangedSubviews.forEach { view in
            infoStack.removeArrangedSubview(view)
        }
        
        InfoLabelType.allCases.forEach { type in
            let label = InfoLabel()
            label.setLabelTitle(of: type)
            label.setLabelContent(of: type, with: data)
            infoStack.addArrangedSubview(label)
        }
    }
}

