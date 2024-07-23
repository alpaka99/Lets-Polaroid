//
//  MSColor.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//
import UIKit

enum MSColor: String {
    case blue = "186FF2"
    case lightGray = "8C8C8C"
    case darkGray = "4D5652"
    case black = "000000"
    case paper = "F2F2F2"
    case white = "FFFFFF"
    case magenta = "F04452"
    
    var color: UIColor? {
        return UIColor.hexToColor(self.rawValue)
    }
}
