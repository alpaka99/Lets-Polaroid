//
//  UIButton+.swift
//  MySplashed
//
//  Created by user on 7/26/24.
//

import UIKit

extension UIButton {
    var config: UIButton.Configuration {
        return self.configuration ?? UIButton.Configuration.plain()
    }
    
    func updateImge(_ systemName: String) {
        var config = self.config
        self.configuration = config.image(systemName: systemName)
    }
    
    func updateTitle(_ title: String) {
        var config = self.config
        self.configuration = config.title(title)
    }
}
