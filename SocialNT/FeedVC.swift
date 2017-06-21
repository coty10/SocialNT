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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdded: CircleImageView!
    @IBOutlet weak var captionField: CustomTextField!
    
    var imagePicker: UIImagePickerController!
    
    var posts = [Post]()
    static var imgCache: NSCache<NSString, UIImage> = NSCache()
    var imgSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
          
            self.posts = [] // This is the new line
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postId: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imgCache.object(forKey: post.imgUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
             return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdded.image = image
            imgSelected = true
        } else {
            print("Coty10: Please select a valid image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Selecting the image
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Adding the post
    @IBAction func addPostPressed(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("Coty10: Please insert a Caption")
            return
        }
        guard let img = imageAdded.image, imgSelected == true else {
            print("Coty10: Please select a valid Image")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imageID = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_STORAGE_PICS.child(imageID).putData(imgData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print("Coty10: Unable to upload to Firebase Storage")
                } else {
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.addPostToFirebase(imgUrl: url)
                    }
                }
            })
        }
        
    }
    
    func addPostToFirebase(imgUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text as AnyObject,
            "imgUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
            ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //Restoring the fields
        captionField.text = ""
        imgSelected = false
        imageAdded.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    
    //Logging out
    @IBAction func logOutPressed(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
       try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    

}
