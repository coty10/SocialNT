//
//  ButtonDesign.swift
//  SocialNT
//
//  Created by Marco Cotugno on 19/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit

private var _buttonDesign: Bool = false

extension UIView {
    
    
    @IBInspectable var buttonDesign: Bool{
        
        get {
            return _buttonDesign
        }
        
        set {
            _buttonDesign = newValue
            
            if _buttonDesign {
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
                
            }else{
                self.layer.borderWidth = 0.0
            }
            
        }
    }
}
