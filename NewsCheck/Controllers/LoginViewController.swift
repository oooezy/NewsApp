//
//  LoginViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class LoginViewController: UIViewController {
    var userModel = UserModel()
    
    // MARK: - IBOutlet
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBGColor
        
        setUpUI()
        
        if let user = Auth.auth().currentUser {
            // 이미 로그인 한 상태일 경우
        }
        loginButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func setUpUI() {
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(hex: 0xE6E6E6).cgColor
        passwordTextField.layer.masksToBounds = true
        
        loginButton.layer.cornerRadius = 10
    }
    
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
                textField.frame.origin.x += 10
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    // MARK: - IBAction
    @IBAction func didTapLoginButton(_ sender: UIButton) {
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
            
            self.textFieldContainerView.addSubview(emailLabel)
            NSLayoutConstraint.activate([
                emailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
                emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor)
            ])
        }
            
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else {
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
            self.textFieldContainerView.addSubview(passwordLabel)
            NSLayoutConstraint.activate([
                passwordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
                passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
            ])
        }
            
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
            if loginSuccess {
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
            else {
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

    // Google
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let signInConfig = GIDConfiguration.init(clientID: clientID)

            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) {_,_ in
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
        }
    }
    
    // Apple
    @IBAction func tappedAppleSignInButton(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    // Kakao
    @IBAction func tappedKakaoSignInButton(_ sender: UIButton) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }
    }
    
    // MARK: - objc
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("User ID : \(userIdentifier)")
                print("User Email : \(email ?? "")")
                print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
                
            default:
                break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
