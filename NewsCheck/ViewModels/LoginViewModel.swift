//
//  LoginViewModel.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/07/12.
//

import Foundation

import RxSwift
import RxRelay

class LoginViewModel {
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map { email, password in
                print("Email: \(email), Password: \(password)")
                return !email.isEmpty && email.contains("@") && email.contains(".") && password.count > 4
            }.startWith(false)
    }
}
