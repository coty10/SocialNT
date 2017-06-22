//
//  SettingsVC.swift
//  SocialNT
//
//  Created by Marco Cotugno on 22/06/17.
//  Copyright © 2017 Marco Cotugno. All rights reserved.
//

import UIKit
import Firebase



class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLbl: CustomTextField!
    @IBOutlet weak var profileImage: CircleImageView!
    
    var currentUser: DatabaseReference!
    var imagePicker: UIImagePickerController!
    
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        currentUsername()
        
    }
    
    func currentUsername() {
        currentUser = DataService.ds.REF_CURRENT_USER
        currentUser.observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let username = dict["username"] as! String
                let profileImg = dict["profilePicUrl"] as! String
                self.usernameLbl.attributedPlaceholder = NSAttributedString(string: username)
                if profileImg == "" {
                    self.profileImage.image = UIImage(named: "profile_icon")
                } else {
                let url = URL(string: profileImg)
                let data = try? Data(contentsOf: url!)
                self.profileImage.image = UIImage(data: data!)
                }
            }
        })
    }
    private func setUserImage(user: User!, data: NSData!) {
        
        let imagePath = "ProfileImage/\(user.uid)/profilePic.jpg"
        
        let imageRef = storageRef.child(imagePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data as Data, metadata: metadata) { (metadata, error) in
            
            if error != nil {
                print(error.debugDescription)
                print("cotyyyyyyyyy")
            } else {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.photoURL = metadata?.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    
                    if error == nil {
                        
                        let userInfo = ["profilePicUrl": String(describing: user.photoURL!)]
                        self.currentUser.updateChildValues(userInfo)
                    } else {
                        print(error.debugDescription)
                    }
                })
            }
            
        }
    }
    @IBAction func changeProfileImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
        } else {
            print("Coty10: Please select a valid image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: Any) {
        if usernameLbl.text == "" {
            usernameLbl.text = "Anonymous"
        }
        let data = UIImageJPEGRepresentation(self.profileImage.image!, 0.2)
        let user = Auth.auth().currentUser
        setUserImage(user: user, data: data! as NSData)
        currentUser.updateChildValues(["username": usernameLbl.text!])
        dismiss(animated: true, completion: nil)
    }
}
