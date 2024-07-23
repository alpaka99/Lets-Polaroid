//
//  InternalPadding.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

import UIKit

protocol InternalPadding {
    var inset: UIEdgeInsets { get set }
    
    var top: CGFloat { get set }
    var left: CGFloat { get set }
    var right: CGFloat { get set }
    var bottom: CGFloat { get set }
}

extension InternalPadding {
    var top: CGFloat {
        get {
            self.inset.top
        }
        set {
            self.inset.top = newValue
        }
    }
    var left: CGFloat {
        get {
            self.inset.left
        }
        set {
            self.inset.left = newValue
        }
    }
    var right: CGFloat {
        get {
            self.inset.right
        }
        set {
            self.inset.right = newValue
        }
    }
    var bottom: CGFloat {
        get {
            self.inset.bottom
        }
        set {
            self.inset.bottom = newValue
        }
    }
}
