//
//  InfoLabel.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class InfoLabel: BaseView {
    let title = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "크기"
        return label
    }()
    let content = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
        label.text = "3098 x 3872"
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        self.addSubview(title)
        self.addSubview(content)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        title.snp.makeConstraints { label in
            label.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            label.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            
        }
        content.snp.makeConstraints { label in
            label.leading.greaterThanOrEqualTo(title.snp.trailing)
                .offset(16)
            label.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            label.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.backgroundColor = .systemOrange
    }
}
