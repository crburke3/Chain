//
//  AdditionalInfoViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/18/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import PopupDialog
import FirebaseFirestore
import Firebase

class AdditionalInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    //@IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var characterCounter: UILabel!
    @IBOutlet weak var bioText: UITextView!
    
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //profilePic.image = "user icon"
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func setPic(_ sender: Any) {
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
    
    
    
    @IBAction func nextPage(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("users").document(phone).updateData(["bio" : bioText.text])
        //Upload profile picture to database and then push vc
        if profilePic.image != nil {
            uploadImage(image: profilePic.image!) { (error) in
            }
        } else {
            masterFire.getCurrentUsersData(phone: phone) { (error) in
                //Get users data
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 16
    }
}
extension AdditionalInfoViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        profilePic.image = image
        // print out the image size as a test
        print(image.size)
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
    
    //Upload Image
    func uploadImage(image: UIImage, completion: @escaping (String)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("users").document("+19802550653")
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
                        masterNav.showPopUp(_title: "Error Uploading Image to Chain", _message: error1.localizedDescription)
                        completion(error1.localizedDescription)
                    } else{
                        completion("Uploaded Profile Pic")
                        masterFire.getCurrentUsersData(phone: self.phone) { (error) in
                            //Get users data
                        }
                        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
                        mainVC.mainChain = PostChain(chainID: "firstChain", load: true)
                        masterNav.pushViewController(mainVC, animated: true)
                    }
                   }
                })
            }
    }
}
