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

class AdditionalInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var characterCounter: UILabel!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet var saveButton: RoundButton!
    
    var phone: String = ""
    let loader = BeautifulLoadScreen(lottieAnimation: .UglyChain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        bioText.delegate = self
        loader.isHidden = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:))))
        profilePic.isUserInteractionEnabled = true
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }

    @objc func imageTapped(sender: UIImageView){
        let popup = PopupDialog(title: "Set Profile Photo", message: "Where do you want to get your profile picture from?")
        let cancelButton = CancelButton(title: "CANCEL") {}
        let imageLibraryButton = DefaultButton(title: "Phone Library") {
            self.getImage(source: "imageLibrary")
        }
        let cameraButton = DefaultButton(title: "Camera") {
            self.getImage(source: "camera")
        }
        popup.addButtons([imageLibraryButton, cameraButton, cancelButton])
        present(popup, animated: true, completion: nil)
    }
        
    @IBAction func skip(_ sender: Any) {
        let firstChain = PostChain(chainName: "firstChain", load: true)
        let mainVC = ChainViewController.initFrom(chain: firstChain)
        masterNav.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        loader.fadeIn()
        let db = Firestore.firestore()
        db.collection("users").document(phone).updateData(["bio" : bioText.text ?? "No Bio Yet"])
        if profilePic.image != nil {
            uploadImage(image: profilePic.image!) { (error) in
                if error != nil{
                    self.loader.fadeOut()
                    self.showPopUp(_title: "Error Uploading Image", _message: "please try again")
                    return
                }else{
                    masterFire.getCurrentUsersData(phone: self.phone) { (error) in
                        self.loader.fadeOut()
                        let explore = masterStoryBoard.instantiateViewController(withIdentifier: mainVcName)
                        masterNav.pushViewController(explore, animated: true)
                    }
                }
            }
        } else {
            loader.fadeOut()
            masterFire.getCurrentUsersData(phone: phone) { (error) in
                self.loader.fadeOut()
                let explore = masterStoryBoard.instantiateViewController(withIdentifier: mainVcName)
                masterNav.pushViewController(explore, animated: true)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count <= 250{
            print(textView.text.count)
            characterCounter.text = "\(textView.text.count)/250"
            return true
        }else{
            return false
        }
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
    func uploadImage(image: UIImage, completion: @escaping (String?)->()) {
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
                        completion(nil)
                    }
               }
            })
        }
    }
}
