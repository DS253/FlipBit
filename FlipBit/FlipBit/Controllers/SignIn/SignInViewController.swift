//
//  SignInViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import FBSDKLoginKit
import Firebase
import GoogleSignIn
import UIKit

class SignInViewController: ViewController, LoginButtonDelegate {
    private lazy var facebookSignInButton: FBLoginButton = {
        let facebookButton = FBLoginButton()
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.permissions = ["email"]
        facebookButton.delegate = self
        return facebookButton
    }()
    
    private lazy var googleButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleSignOutButton: UIButton = {
        let button = UIButton(title: "Sign Out", textColor: themeManager.buyTextColor, font: UIFont.title3.bold)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false { GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
    }
    
    override func setup() {
        super.setup()
        
        setSignInState()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(googleButton)
        view.addSubview(googleSignOutButton)
        view.addSubview(facebookSignInButton)
        
        
        //        if let token = AccessToken.current, !token.isExpired {
        //            print("FB Logged In!!!!")
        //        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        googleButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        facebookSignInButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(googleButton.snp.bottom).offset(Space.margin16)
        }
        
        googleSignOutButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalToSuperview().inset(Space.margin16)
            make.height.equalTo(Space.margin48)
        }
    }
    
    func setSignInState() {
        googleButton.isHidden = GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false
        googleSignOutButton.isHidden = !(GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false)
    }
    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            GIDSignIn.sharedInstance()?.disconnect()
            setSignInState()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil {
            if result!.isCancelled {
                return
            }
        }
        if let error = error {
            print(error.localizedDescription)
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Unable to login to Facebook: error [\(error)]")
                return
            }
            print("Facebook user is signed in \(String(describing: authResult?.user.uid))")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("Facebook user is signed out")
    }
}
