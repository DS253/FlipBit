//
//  SignInViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import AuthenticationServices
import CryptoKit
import FirebaseUI
import UIKit

class SignInViewController: ViewController, FUIAuthDelegate {
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(title: "Sign In", textColor: themeManager.buyTextColor, font: UIFont.title3.bold)
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(title: "Sign Out", textColor: themeManager.buyTextColor, font: UIFont.title3.bold)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private var currentNonce: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    @objc func appleIDStateRevoked() {
        // log out user, change UI etc
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(appleSignInButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        appleSignInButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
    
    @objc func appleSignInTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        // request full name and email from the user's Apple ID
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication is successful
        self.currentNonce = randomNonceString()
        
        
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        if let nonce = currentNonce { request.nonce = sha256(nonce) }
        
        // pass the request to the initializer of the controller
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        // similar to delegate, this will ask the view controller
        // which window to present the ASAuthorizationController
        authController.presentationContextProvider = self
        
        // delegate functions will be called when user data is
        // successfully retrieved or error occured
        authController.delegate = self
        
        // show the Sign-in with Apple dialog
        authController.performRequests()
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("SIGNED IN")
    }
    
    @objc func signIn() {
        
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        //        let provider = FUIOAuth.twitterAuthProvider()
        
        
        let providers: [FUIAuthProvider] = [FUIOAuth.appleAuthProvider(), FUIGoogleAuth(), FUIFacebookAuth(), FUIOAuth.twitterAuthProvider()]
        authUI.providers = providers
        
        let authVC = authUI.authViewController()
        present(authVC, animated: true)
    }
    
    @objc func signOut() throws {
        
        // Check provider ID to verify that the user has signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        }
        
        // Perform sign out from Firebase
        try Auth.auth().signOut()
    }
}

extension SignInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // return the current view window
        return self.view.window!
    }
}

extension SignInViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // unique ID for each user, this uniqueID will always be returned
            let userID = appleIDCredential.user
            
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
                credentialState, error in
                
                switch(credentialState){
                case .authorized:
                    print("user remain logged in, proceed to another view")
                    self.performSegue(withIdentifier: "LoginToUserSegue", sender: nil)
                case .revoked:
                    print("user logged in before but revoked")
                case .notFound:
                    print("user haven't log in before")
                default:
                    print("unknown state")
                }
            })
            
            // save it to user defaults
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            
            guard let nonce = self.currentNonce
                else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }
            
            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }
            
            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
                    }
                })
            }
            
            // on the initial view controller or somewhere else, check the userdefaults
            //                if let userID = UserDefaults.standard.string(forKey: "userID") {
            //                    performSegue(withIdentifier: "LoginToMainViewSegue", sender: user)
            //                }
            
            // optional, might be nil
            let email = appleIDCredential.email
            
            // optional, might be nil
            let givenName = appleIDCredential.fullName?.givenName
            
            // optional, might be nil
            let familyName = appleIDCredential.fullName?.familyName
            
            // optional, might be nil
            let nickName = appleIDCredential.fullName?.nickname
            
            /*
             useful for server side, the app can send identityToken and authorizationCode
             to the server for verification purpose
             */
            var identityToken : String?
            if let token = appleIDCredential.identityToken {
                identityToken = String(bytes: token, encoding: .utf8)
            }
            
            var authorizationCode : String?
            if let code = appleIDCredential.authorizationCode {
                authorizationCode = String(bytes: code, encoding: .utf8)
            }
            
            // do what you want with the data here
            
        }
    }
}
