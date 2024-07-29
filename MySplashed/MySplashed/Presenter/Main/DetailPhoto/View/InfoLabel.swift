//
//  InfoLabel.swift
//  MySplashed
//
//  Created by user on 7/27/24.
//

import UIKit

import SnapKit

final class InfoLabel: BaseView {
    private let title = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let content = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
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
    
    func setLabelTitle(of type: InfoLabelType) {
        switch type {
        case .size:
            title.text = "크기"
        case .views:
            title.text = "조회수"
        case .downloads:
            title.text = "다운로드"
        }
    }
    
    func setLabelContent(of type: InfoLabelType, with data: DetailPhotoModel) {
        switch type {
        case .size:
            let width = data.imageData?.unsplashResponse.width.formatted() ?? ""
            let height = data.imageData?.unsplashResponse.height.formatted() ?? ""
            content.text = "\(width) x \(height)"
        case .views:
            content.text = data.statisticsData?.views.total.formatted()
        case .downloads:
            content.text = data.statisticsData?.downloads.total.formatted()
        }
    }
}
