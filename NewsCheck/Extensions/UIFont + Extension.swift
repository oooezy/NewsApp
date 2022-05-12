//
//  UIFont + Extension.swift
//  NewsApp
//
//  Created by 이은지 on 2022/03/23.
//

import UIKit

extension UIFont {
    class func NanumSquare(type: NanumSquareType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum NanumSquareType {
        case Light
        case Regular
        case Bold
        case ExtraBold
        
        var name: String {
            switch self {
            case .Light:
                return "NanumSquareOTFL"
            case .Regular:
                return "NanumSquareOTFR"
            case .Bold:
                return "NanumSquareOTFB"
            case .ExtraBold:
                return "NanumSquareOTFEB"
            }
        }
    }
}
