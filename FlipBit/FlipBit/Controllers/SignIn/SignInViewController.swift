//
//  SignInViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import AuthenticationServices
import FirebaseAuth
import UIKit

class SignInViewController: ViewController {
    
    private lazy var titleLabel: UILabel = {
        UILabel(text: "FlipBit", font: .largeTitle, textColor: .black, textAlignment: .center)
    }()
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(title: "Sign Out", textColor: .white)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    var currentNonce: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateRevoked), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    @objc func appleIDStateRevoked() {
        // log out user, change UI etc
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(titleLabel)
        view.addSubview(appleSignInButton)
        view.addSubview(signOutButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalToSuperview().inset(78.0)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).inset(32.0)
        }
    }
    
    @objc func appleSignInTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        // Request full name and email from the user's Apple ID.
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication is successful.
        self.currentNonce = String().randomNonceString()
        
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest.
        if let nonce = currentNonce { request.nonce = nonce.sha256() }
        
        // Pass the request to the initializer of the controller.
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        authController.performRequests()
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
