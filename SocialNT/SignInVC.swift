//
//  SignInVC.swift
//  SocialNT
//
//  Created by Marco Cotugno on 19/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }// end viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    
    @IBAction func facebookLoginPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Coty10: Unable to login with Facebook - \(error.debugDescription)")
            } else if result?.isCancelled == true {
                print("Coty10: User cancelled Facebook Login")
            } else {
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }// end facebookLoginPressed
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Coty10: Unable to Login with Firebase - \(error.localizedDescription)")
            }else {
             print("Coty10: Successufully logged in with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print("Coty10: Email Successfully signed in with Firebase")
                    if let user = user {
                     self.completeSignIn(id: user.uid)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("Coty10: Unable to sign in with Email in Firebase")
                        } else {
                            print("Coty10: User registered and signed in with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    } // end of signedInPressed
    
    func completeSignIn(id: String) {
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}// end SignInVC

