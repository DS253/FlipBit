//
//  SignInViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit

class SignInViewController: ViewController {
    
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
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        googleButton.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
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
}
