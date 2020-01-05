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

class CameraViewController: UIViewController {

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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraTouched(_ sender: Any) { //Create Chain Image
        //Capture Image
        captureImage()
        //Confirm Image, if denied then take another image
        
        //Once confirmed, upload to FireBase and then append to chain
        
    }
    
    
    @IBAction func cameraHeldDown(_ sender: Any) {
        print("held down")
    }
    
    @IBAction func cameraReleased(_ sender: Any) {
        print("released")
    }
    
    func captureImage() {
        session.capture({ (image, settings) in
            self.previewView.isHidden = true
            self.imageView.image = image
            self.imageView.isHidden = false
            print(self.imageView.frame)
            self.cameraButton.isHidden = true
            //Present confirm or denie buttons
            
                let photoEditor = UIStoryboard(name: "Main", bundle: Bundle(for: PhotoEditorViewController.self)).instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController

                //PhotoEditorDelegate
                photoEditor.photoEditorDelegate = self as! PhotoEditorDelegate

                //The image to be edited
                photoEditor.image = image

                //Stickers that the user will choose from to add on the image
                photoEditor.stickers.append(UIImage(named: "sticker" )!)

                //To hide controls - array of enum control
                photoEditor.hiddenControls = [.crop, .draw, .share]

                //Present the View Controller
                self.present(photoEditor, animated: true, completion: nil)
            
            masterFire.appendChain(chainID: self.chainID, image: self.imageView.image!) { (error) in
                if let error = error {
                    print("Error appending to chain \(error)")
                } else {
                    
                }
            }
            
        }) { (error) in
           
        }
    }
}
