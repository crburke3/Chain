//
//  CameraViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import CameraKit_iOS
import Kingfisher
import Firebase

class CameraViewController: UIViewController {

    @IBOutlet var previewView: CKFPreviewView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    
    let session = CKFPhotoSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView = CKFPreviewView(frame: self.view.bounds)
        view.addSubview(previewView)
        previewView.session = session
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraTouched(_ sender: Any) { //Create Chain Image
        session.capture({ (image, settings) in
            self.previewView.isHidden = true
            self.imageView.image = image
            self.imageView.isHidden = false
            print(self.imageView.frame)
            self.cameraButton.isHidden = true
            //Upload image to Firebase, get link
            //Create ChainImage
            guard let imageTaken = self.imageView.image, let data = imageTaken.jpegData(compressionQuality: 1.0) else {
                print("Error loading image")
                return
            }
            let imageName = UUID().uuidString
            let imageReference = Storage.storage().reference().child("Chain Images").child(imageName) //
            let metaDataForImage = StorageMetadata() //
            metaDataForImage.contentType = "image/jpeg" //
            
            imageReference.putData(data, metadata: metaDataForImage) { (meta, err) in //metadata: nil to metaDataForImage
                if let err = err {
                    print("Error sending photo to cloud")
                    return
                }
                imageReference.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Error loading URL")
                        return
                    }
                    guard let url = url else{
                        print("Error loading URL")
                        return
                    }
                    let dataRef = Firestore.firestore().collection("chains").document("firstChain")
                    let defaults = UserDefaults.standard
                    let urlString = url.absoluteString //Hold URL
                    let upload = ChainImage(link: urlString, user: "mbrutkow", image: imageTaken)
                    let imageArraySave = "mbrutkow" + "Images"
                    dataRef.updateData(["posts": FieldValue.arrayUnion([upload.toDict()])]) //1 per second edit max
                })
            }
        }) { (error) in
        }
    }
    
    @IBAction func cameraHeldDown(_ sender: Any) {
        print("held down")
    }
    
    @IBAction func cameraReleased(_ sender: Any) {
        print("released")
    }
}
