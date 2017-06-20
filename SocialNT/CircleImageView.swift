//
//  CircleImageView.swift
//  SocialNT
//
//  Created by Marco Cotugno on 20/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }


}
