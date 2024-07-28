//
//  PaddingImageView.swift
//  MySplashed
//
//  Created by user on 7/24/24.
//

//import UIKit

//final class PaddingImageView: UIImageView, InternalPadding {
//    var inset: UIEdgeInsets
//    
//    override init(frame: CGRect) {
//        self.inset = .zero
//        super.init(frame: frame)
//    }
//    
//    convenience init(padding: UIEdgeInsets) {
//        self.init(frame: .zero)
//        self.inset = padding
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        var size = super.intrinsicContentSize
//        size.width += inset.left + inset.right
//        size.height += inset.top + inset.bottom
//        return size
//    }
//}
