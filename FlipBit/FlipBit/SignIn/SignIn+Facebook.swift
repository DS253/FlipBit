//
//  SignIn+Facebook.swift
//  FlipBit
//
//  Created by Daniel Stewart on 8/11/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import FBSDKLoginKit
import FirebaseAuth
import Foundation

/// The Signin process using Facebook credentials.
extension SignIn: LoginButtonDelegate {
    
    /// Signin callback when Facebook credentials have been successfully retrieved.
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error != nil, !(result?.isCancelled ?? false) else { return }
        
        if let error = error { print(error.localizedDescription) }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        // Send Facebook credentials to Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Unable to login to Facebook: error [\(error)]")
                return
            }
            print("Facebook user is signed in \(String(describing: authResult?.user.uid))")
        }
    }
    
    /// After signing out of Facebook, sign out of Firebase.
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
