//
//  Posts.swift
//  SocialNT
//
//  Created by Marco Cotugno on 20/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import Foundation
import Firebase



class Post {
    
    private var _caption: String!
    private var _imgUrl: String!
    private var _postId: String!
    private var _likes: Int!
    private var _postRef: DatabaseReference!
    
    
    var caption: String {
        return _caption
    }
    
    var imgUrl: String {
        return _imgUrl
    }
    
    var postId: String {
        return _postId
    }
    
    var likes: Int {
        return _likes
    }
    
    init(caption: String, imgUrl: String, likes: Int) {
        
        self._caption = caption
        self._imgUrl = imgUrl
        self._likes = likes
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        
        self._postId = postId
    
        if let caption = postData["caption"] {
            self._caption = caption as! String
        }
        
        if let imgUrl = postData["imgUrl"] {
            self._imgUrl = imgUrl as! String
        }
        
        if let likes = postData["likes"] {
            self._likes = likes as! Int
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postId)
    }
    
    func addRemoveLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
