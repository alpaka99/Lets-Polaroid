//
//  UIButton+.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import UIKit

extension UIButton {
    var config: UIButton.Configuration {
        return self.configuration ?? UIButton.Configuration.plain()
    }
    
    func image(named: String) -> Self {
        var config = config
        config.image = UIImage(named: named)
        self.configuration = config
        return self
    }
    
    func image(systemName: String) -> Self {
        var config = config
        config.image = UIImage(systemName: systemName)
        self.configuration = config
        return self
    }
    
    func title(_ title: String) -> Self {
        var config = config
        config.attributedTitle = AttributedString(stringLiteral: title)
        self.configuration = config
        return self
    }
    
    func backgroundColor(_ color: UIColor) -> Self {
        var config = config
        config.background.backgroundColor = color
        self.configuration = config
        return self
    }
    
    func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> Self {
        var config = config
        let transformer = UIConfigurationTextAttributesTransformer { oldValue in
            var newValue = oldValue
            newValue.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
            return newValue
        }
        
        config.titleTextAttributesTransformer = transformer
        self.configuration = config
        return self
    }
    
    func cornerStyle(_ cornerStyle: Configuration.CornerStyle) -> Self {
        var config = config
        config.cornerStyle = cornerStyle
        self.configuration = config
        return self
    }
}
