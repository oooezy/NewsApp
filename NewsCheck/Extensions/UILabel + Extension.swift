//
//  UILabel + Extension.swift
//  NewsApp
//
//  Created by 이은지 on 2022/03/23.
//

import UIKit

extension UILabel {
    func linespace(spacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = spacing
            attributeString.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: style,
                range: NSMakeRange(0, attributeString.length)
            )
            
            self.attributedText = attributeString }
    }
    
}
