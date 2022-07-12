//
//  LoginDetailViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    var userModel = UserModel()
        
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "회원가입"
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .lightFontColor
        
        configureUI()

        // 키보드 내리기
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordConfirmTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        signUpButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightFontColor]
        
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
    
    func configureUI() {
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
        
        signUpButton.layer.cornerRadius = 10
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }

    // MARK: - IBAction
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty else { return }

        if userModel.isValidEmail(id: email) {
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        } else {
            emailTextField.shakeTextField()
            let emailLabel = UILabel().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "이메일 형식을 확인해 주세요."
                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                $0.textColor = UIColor.red
                $0.tag = 100
            }
            
            self.view.addSubview(emailLabel)
            NSLayoutConstraint.activate([
                emailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
                emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor)
            ])
        }
        
        if userModel.isValidPassword(pwd: password) {
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        } else {
            passwordTextField.shakeTextField()
            let passwordLabel = UILabel().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "비밀번호 형식을 확인해 주세요. (대소문자, 숫자가 포함 8자리 이상)"
                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                $0.textColor = UIColor.red
                $0.tag = 101
            }
            
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
            passwordConfirmTextField.shakeTextField()
            let passwordLabel = UILabel().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "비밀번호가 다릅니다."
                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                $0.textColor = UIColor.red
                $0.tag = 102
            }
            
            self.view.addSubview(passwordLabel)
            NSLayoutConstraint.activate([
                passwordLabel.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: 10),
                passwordLabel.leadingAnchor.constraint(equalTo: passwordConfirmTextField.leadingAnchor)
            ])
        }
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) && password == passwordConfirm {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                        switch ErrorCode {
                        case AuthErrorCode.invalidEmail:
                            self.emailTextField.shakeTextField()
                            let joinFailLabel = UILabel().then {
                                $0.translatesAutoresizingMaskIntoConstraints = false
                                $0.text = "유효하지 않은 이메일 입니다."
                                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                                $0.textColor = UIColor.red
                                $0.tag = 103
                            }

                            self.view.addSubview(joinFailLabel)
                            NSLayoutConstraint.activate([
                                joinFailLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10),
                                joinFailLabel.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor)
                            ])
                        case AuthErrorCode.emailAlreadyInUse:
                            self.emailTextField.shakeTextField()
                            let joinFailLabel = UILabel().then {
                                $0.translatesAutoresizingMaskIntoConstraints = false
                                $0.text = "이미 가입되어있는 이메일입니다."
                                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                                $0.textColor = UIColor.red
                                $0.tag = 103
                            }

                            self.view.addSubview(joinFailLabel)
                            NSLayoutConstraint.activate([
                                joinFailLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10),
                                joinFailLabel.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor)
                            ])
                        default:
                            print(ErrorCode)
                        }

                    }
                } else {
                    self.showMainViewController()
                }
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
