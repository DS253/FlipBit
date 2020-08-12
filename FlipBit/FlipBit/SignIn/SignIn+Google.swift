//
//  SignIn+Google.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/10/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn

/// The Signin process using Google credentials.
extension SignIn: GIDSignInDelegate {
    
    /// Assign GIDSignIn delegate and client ID.
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    /// Signin callback when Google credentials have been successfully retrieved.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        // Send Google credentials to Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Google user is signed in \(String(describing: authResult?.user.uid))")
        }
    }
}
