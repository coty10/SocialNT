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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }// end viewDidLoad

    
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
            }
        }
    }
    

}// end SignInVC

