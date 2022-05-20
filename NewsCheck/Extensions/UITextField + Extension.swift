//
//  UITextField + Extension.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func shakeTextField() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.x -= 5
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.origin.x += 10
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                     self.frame.origin.x -= 5
                })
            })
        })
    }
}
