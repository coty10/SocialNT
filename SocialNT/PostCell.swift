//
//  PostCell.swift
//  SocialNT
//
//  Created by Marco Cotugno on 20/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var numberOfLikes: UILabel!

    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(post: Post) {
        self.post = post
        self.captionText.text = post.caption
        self.numberOfLikes.text = "\(post.likes)"
        
    }

}
