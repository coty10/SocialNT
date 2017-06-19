//
//  FeedVC.swift
//  SocialNT
//
//  Created by Marco Cotugno on 19/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
       try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    

}
