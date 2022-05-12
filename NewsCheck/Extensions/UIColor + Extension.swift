//
//  UIColor + Extension.swift
//  NewsApp
//
//  Created by 이은지 on 2022/03/23.
//

import UIKit

extension UIColor {
    
    static let mainColor = UIColor(hex: 0xF5B309)
    static let fontColorGray = UIColor(hex: 0x939393)
    static let fontColorBlack = UIColor(hex: 0x262626)
    static let lightBGColor = UIColor(hex: 0xFAFAFA)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
