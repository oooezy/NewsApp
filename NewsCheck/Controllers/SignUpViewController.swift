//
//  LoginDetailViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit

class SignUpViewController: UIViewController {
    var userModel = UserModel() // 인스턴스 생성
        
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBGColor
        
        self.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.fontColorGray]

        // 키보드 내리기
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordConfirmTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
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
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        passwordConfirmTextField.addLeftPadding()
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        passwordTextField.layer.masksToBounds = true
        
        passwordConfirmTextField.layer.cornerRadius = 10
        passwordConfirmTextField.layer.borderWidth = 1.0
        passwordConfirmTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        passwordConfirmTextField.layer.masksToBounds = true
        
        confirmButton.layer.cornerRadius = 10
    }
    
    // 회원 확인 method
    func isUser(id: String) -> Bool {
        for user in userModel.users {
            if user.email == id {
                return true // 이미 회원인 경우
            }
        }
        return false
    }
    
    func shakeTextField(textField: UITextField) -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 10
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }

    // MARK: - IBAction
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        guard let name = emailTextField.text, !name.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty else { return }

        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        } else {
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
                emailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
                emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor)
            ])
        } // 이메일 형식 오류
        
        if userModel.isValidPassword(pwd: password) {
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        } else {
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
                passwordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
                passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
            ])
        }
        
        if password == passwordConfirm {
            if let removable = self.view.viewWithTag(102) {
                removable.removeFromSuperview()
            }
        } else {
            shakeTextField(textField: passwordConfirmTextField)
            let passwordLabel: UILabel = {
                let label = UILabel()
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "비밀번호가 다릅니다."
                label.font = UIFont.NanumSquare(type: .Regular, size: 12)
                label.textColor = UIColor.red
                label.tag = 102
                
                return label
            }()
            
            self.view.addSubview(passwordLabel)
            NSLayoutConstraint.activate([
                passwordLabel.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: 10),
                passwordLabel.leadingAnchor.constraint(equalTo: passwordConfirmTextField.leadingAnchor)
            ])
        }
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) && password == passwordConfirm {
            let joinFail: Bool = isUser(id: email)
            if joinFail {
                shakeTextField(textField: emailTextField)
                let joinFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
                joinFailLabel.text = "이미 가입된 이메일입니다."
                joinFailLabel.textColor = UIColor.red
                joinFailLabel.tag = 103
                
                self.view.addSubview(joinFailLabel)
            } else {
                if let removable = self.view.viewWithTag(103) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMap", sender: self)
            }
        }
                
    }
    
    // MARK: - objc
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
    
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordConfirmTextField.becomeFirstResponder()
        }
    }
}
