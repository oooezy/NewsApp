//
//  LoginDetailViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit

class LoginDetailViewController: UIViewController {
    var userModel = UserModel() // 인스턴스 생성
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    func loginCheck(id: String, pwd: String) -> Bool {
        for user in userModel.users {
            if user.email == id && user.password == pwd {
                return true
            }
        }
        return false
    }
    
    func shakeTextField(textField: UITextField) -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
//        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
//        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        confirmButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
          self,
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.removeObserver(
          self,
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func setUpUI() {
        confirmButton.layer.cornerRadius = 15
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
            
        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            let emailLabel: UILabel = {
                let label = UILabel()
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "이메일 형식을 확인해 주세요."
                label.font = UIFont.NanumSquare(type: .Regular, size: 12)
                label.textColor = UIColor.red
                label.tag = 100
                
                return label
            }()
            
            self.view.addSubview(emailLabel)
            NSLayoutConstraint.activate([
                emailLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
                emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
            
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            let passwordLabel: UILabel = {
                let label = UILabel()
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "비밀번호 형식을 확인해 주세요."
                label.font = UIFont.NanumSquare(type: .Regular, size: 12)
                label.textColor = UIColor.red
                label.tag = 101
                
                return label
            }()
            self.view.addSubview(passwordLabel)
            NSLayoutConstraint.activate([
                passwordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
                passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
            
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
            if loginSuccess {
                print("로그인 성공")
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
            else {
                print("로그인 실패")
                shakeTextField(textField: emailTextField)
                shakeTextField(textField: passwordTextField)
                let loginFailLabel: UILabel = {
                    let label = UILabel()
                    
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = "아이디나 비밀번호가 다릅니다."
                    label.font = UIFont.NanumSquare(type: .Regular, size: 12)
                    label.textColor = UIColor.red
                    label.tag = 102
                    
                    return label
                }()
                self.view.addSubview(loginFailLabel)
                NSLayoutConstraint.activate([
                    loginFailLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
                    loginFailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
            }
        }
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keybaordRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keybaordRectangle.height
          self.keyboardHeightConstraint.constant = keyboardHeight
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardHeightConstraint.constant = 0
    }
}
