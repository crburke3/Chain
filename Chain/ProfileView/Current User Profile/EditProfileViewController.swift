//
//  EditProfileViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import PopupDialog
import Firebase

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //Edit Photo, Username, Favorited Chains, Friends, Block List
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var bio: UITextView!
    
    var currentProfilePhotoURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpImage()
        username.text = currentUser.username
        name.text = currentUser.name
        bio.text = currentUser.bio
    }
    
    func getImage(source: String) {
        let vc = UIImagePickerController()
        if source == "camera" {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        let popup = PopupDialog(title: "Set Profile Photo", message: "Where do you want to get your profile picture from?")
        let cancelButton = CancelButton(title: "CANCEL") {
            print("Canceled")
        }
        let imageLibraryButton = DefaultButton(title: "Phone Library") {
            self.getImage(source: "imageLibrary")
        }
        let cameraButton = DefaultButton(title: "Camera") {
            self.getImage(source: "camera")
        }
        popup.addButtons([imageLibraryButton, cameraButton, cancelButton])
        present(popup, animated: true, completion: nil)
    }
    
    @IBAction func viewFriends(_ sender: Any) {
        let friendsVC = FriendsViewController()
        masterNav.pushViewController(friendsVC, animated: true)
    }
    
    @IBAction func viewBlocked(_ sender: Any) {
    }
    
    @IBAction func goBack(_ sender: Any) {
        changedInfo()
    }
    


    
    func uploadImage(image: UIImage, completion: @escaping (String)->()) {
            var urlString = "" //Will hold URL string to create Chain Image
            let firestoreRef = Firestore.firestore().collection("users").document(currentUser.phoneNumber)
            let data = image.jpegData(compressionQuality: 1.0)!
            let imageName = UUID().uuidString
            let imageReference = Storage.storage().reference().child("Fitwork Images").child(imageName)
            let metaDataForImage = StorageMetadata() //
            metaDataForImage.contentType = "image/jpeg" //
            imageReference.putData(data, metadata: metaDataForImage) { (meta, err1) in //metadata: nil to metaDataForImage
                if err1 != nil {completion("Error uploading to cloud: \(err1!.localizedDescription)"); return}
                imageReference.downloadURL(completion: { (url, err2) in
                    if err2 != nil {completion("Error getting URL"); return}
                    if url == nil {completion("Error loading URL"); return}
                    urlString = url!.absoluteString //Hold URL
                    print(urlString)
                    firestoreRef.updateData([
                        "profilePhoto": urlString
                    ]) { (err1) in
                        if let error1 = err1{
                            masterNav.showPopUp(_title: "Error Uploading Image", _message: error1.localizedDescription)
                            completion(error1.localizedDescription)
                        } else{
                            completion("Uploaded Profile Pic")
                            //
                            self.currentProfilePhotoURL = urlString
                        }
                       }
                    })
                }
        }
    
    
    func changedInfo() {
        if currentUser.name != name.text || currentUser.bio != bio.text || currentUser.username != username.text || currentUser.profile != currentProfilePhotoURL {
            //Something has changed, upload changes
            let db = Firestore.firestore()
            db.collection("users").document(currentUser.phoneNumber).updateData(["username" : username.text, "bio": bio.text, "name": name.text]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    //Update currentUser object
                    currentUser.username = self.username.text ?? ""
                    currentUser.bio = self.bio.text
                    currentUser.name = self.name.text ?? ""
                    self.navigationController?.popViewController(animated: true)
                    self.uploadImage(image: self.profilePic.image!) { (error) in
                        //
                    }
                }
            }
            
        } else {
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func setUpImage() {
        let url = URL(string: currentUser.profile)
        profilePic.kf.setImage(with: url)
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.profilePic.image = image
        
        // print out the image size as a test
        print(image.size)
    }
}
