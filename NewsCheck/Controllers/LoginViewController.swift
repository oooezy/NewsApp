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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    override func viewDidLoad() {
        setUpUI()
    }
    
    func setUpUI() {
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        confirmButton.layer.cornerRadius = 15
    }
    
    // Google
    @IBAction func tappedGoogleSignInButton(_ sender: UIButton) {
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
