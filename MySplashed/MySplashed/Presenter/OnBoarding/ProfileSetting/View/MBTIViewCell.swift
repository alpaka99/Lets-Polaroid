//
//  MBTIViewCell.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

import SnapKit

final class MBTIViewCell: BaseCollectionViewCell {
    private(set) var label = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override func configureHierarchy() {
        super.configureHierarchy()
        self.addSubview(label)
    }
    
    override func configureLayout() {
        super.configureUI()
        label.snp.makeConstraints { view in
            view.width.equalTo(self.snp.width)
            view.height.equalTo(label.snp.width)
                .multipliedBy(1)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        deselected()
    }
    
    func configureAlphabet(_ alphabet: String) {
        label.text = alphabet.uppercased()
    }
    
    func selected() {
        label.backgroundColor = MSColor.blue.color
        label.textColor = MSColor.white.color
    }
    
    func deselected() {
        label.backgroundColor = .white
        label.textColor = MSColor.darkGray.color
        label.layer.borderColor = MSColor.darkGray.color?.cgColor
        label.layer.borderWidth = 1
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        label.layer.cornerRadius = label.frame.width / 2
    }
}
