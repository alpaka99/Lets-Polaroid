//
//  UIColor+.swift
//  MySplashed
//
//  Created by user on 7/23/24.
//

import UIKit

extension UIColor {
    static func hexToColor(_ hexValue: String) -> UIColor? {
        let r, g, b: CGFloat
        
        let hexValue = hexValue.removeOnePrefix("#")
        if hexValue.count == 6 {
            let scanner = Scanner(string: hexValue)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000FF)) / 255
                
                return UIColor(red: r, green: g, blue: b, alpha: 1)
            }
        }
        return nil
    }
    
    func colorToHex() -> String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            getRed(&r, green: &g, blue: &b, alpha: &a)
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

            return String(format:"#%06x", rgb)
        }
}
