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
import iOSPhotoEditor

class CameraViewController: UIViewController, PhotoEditorDelegate {

    

    @IBOutlet var previewView: CKFPreviewView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    let session = CKFPhotoSession()
    var chainID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView = CKFPreviewView(frame: self.view.bounds)
        view.addSubview(previewView)
        previewView.session = session
        cameraButton.isHidden = false
        view.bringSubviewToFront(cameraButton)
    }
    
    @IBAction func cameraTouched(_ sender: Any) { //Create Chain Image
        captureImage()
    }
    
    @IBAction func cameraHeldDown(_ sender: Any) {
        print("held down")
    }
    
    @IBAction func cameraReleased(_ sender: Any) {
        print("released")
    }
    
    func captureImage() {
        session.capture({ (image, settings) in
           /* self.previewView.isHidden = true
            self.imageView.image = image
            self.imageView.isHidden = false
            print(self.imageView.frame)
            self.cameraButton.isHidden = true
            */
            let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.image = image
            //photoEditor.stickers.append(UIImage(named: "sticker" )!)
            photoEditor.hiddenControls = [.share]
            photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
            self.present(photoEditor, animated: true, completion: nil)
        }) { (error) in
           
        }
    }
    
    func doneEditing(image: UIImage) {
        masterFire.appendChain(chainID: self.chainID, image: image) { (error) in
            if let error = error {
                print("Error appending to chain \(error)")
            } else {

            }
        }
        let indexOfPost = 
        masterFire.updateFriendsFeed(chainID: self.chainID, userID: "mbrutkow") { (error) in
            if let error = error {
                print("Error updating friend's feed")
            } else {
                
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    func canceledEditing() {
        
    }
}
