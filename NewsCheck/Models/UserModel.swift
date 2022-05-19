//
//  UserModel.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import Foundation

final class UserModel {
    struct User {
        var email: String
        var password: String
    }
        
    var users: [User] = [
        User(email: "abc1234@naver.com", password: "test1234"),
        User(email: "abc1234@gmail.com", password: "test1234")
    ]
        
    // 아이디 형식 검사
    func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
        
    // 비밀번호 형식 검사
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,50}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
}
