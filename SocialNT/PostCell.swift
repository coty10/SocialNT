//
//  PostCell.swift
//  SocialNT
//
//  Created by Marco Cotugno on 20/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit
import Firebase

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
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.captionText.text = post.caption
        self.numberOfLikes.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imgUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("Coty10: Unable to get image from Firebase Storage")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imgCache.setObject(img, forKey: post.imgUrl as NSString)
                        }
                    }
                }
            })
        }
        
    }

}
