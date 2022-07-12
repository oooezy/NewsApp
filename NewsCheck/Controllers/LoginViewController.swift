//
//  LoginViewController.swift
//  NewsCheck
//
//  Created by 이은지 on 2022/05/15.
//

import UIKit

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Then

class LoginViewController: UIViewController {
    
    var userModel = UserModel()
    private var currentNonce: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autoLoginButton: UIButton!
    
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        loginButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let autoLogin = UserDefaults.standard.string(forKey: "autoLogin") {
            if autoLogin == "true" && Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "showMain", sender: self)
            } else {
                return
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func configureUI() {
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
    
    func kakoLoginWithWeb() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                _ = oauthToken
                
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        let email = user?.kakaoAccount?.email
                        let password = String(describing: user?.id)
                        
                        Auth.auth().createUser(withEmail: email!, password: password) { user, error in
                            if let error = error {
                                print("FB : signup failed")
                                print(error)
                                Auth.auth().signIn(withEmail: email!, password: password, completion: nil)
                            } else {
                                print("FB : signup success")
                            }
                        }
                    }
                }
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
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
        
        self.textFieldContainerView.addSubview(emailLabel)
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
                $0.text = "비밀번호 형식을 확인해 주세요."
                $0.font = UIFont.NanumSquare(type: .Regular, size: 12)
                $0.textColor = UIColor.red
                $0.tag = 101
            }
            self.textFieldContainerView.addSubview(passwordLabel)
            NSLayoutConstraint.activate([
                passwordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
                passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
            ])
        }
            
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            if authResult != nil {
                self?.performSegue(withIdentifier: "showMain", sender: self)
            } else {
                self?.emailTextField.shakeTextField()
                self?.passwordTextField.shakeTextField()
            }
        }
    }

    @IBAction func autoLoginAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            UserDefaults.standard.set("true", forKey: "autoLogin")
        } else {
            UserDefaults.standard.set("false", forKey: "autoLogin")
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
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        startSignInWithAppleFlow()
    }

    // Kakao
    @IBAction func kakaoLoginButtonTapped(_ sender: UIButton) {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    print(error)
                    if UserApi.isKakaoTalkLoginAvailable() {
                        self.kakoLoginWithWeb()
                    }
                } else {
                    self.performSegue(withIdentifier: "showMain", sender: self)
                }
            }
        } else if UserApi.isKakaoTalkLoginAvailable() {
            self.kakoLoginWithWeb()
        }
    }

    // MARK: - objc
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
}

// MARK: - Extension
extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }

                self.performSegue(withIdentifier: "showMain", sender: self)
            }
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

