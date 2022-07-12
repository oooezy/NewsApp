//
//  FindPwdViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/21.
//

import UIKit
import FirebaseAuth

class FindPwdViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var findPwdButton: UIButton!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .fontColorGray
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.fontColorGray]
        
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
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        emailTextField.layer.masksToBounds = true
        
        findPwdButton.layer.cornerRadius = 10
    }

    @IBAction func didTapFindPwdButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                self.emailTextField.shakeTextField()
                let emailLabel = UILabel().then {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.text = "이메일을 다시 확인해주세요."
                    $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                    $0.textColor = UIColor.red
                    $0.tag = 100
                }
                
                self.view.addSubview(emailLabel)
                NSLayoutConstraint.activate([
                    emailLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 10),
                    emailLabel.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor)
                ])
            } else {
                let alert = UIAlertController(title:"메일을 확인해주세요.",
                    message: "",
                    preferredStyle: UIAlertController.Style.alert)

                let yes = UIAlertAction(title: "확인", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(yes)
                self.present(alert, animated: true,completion: nil)
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
}

