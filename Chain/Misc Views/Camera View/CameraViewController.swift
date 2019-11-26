//
//  CameraViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import CameraKit_iOS


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
    
    @IBAction func cameraTouched(_ sender: Any) {
        session.capture({ (image, settings) in
            self.previewView.isHidden = true
            self.imageView.image = image
            self.imageView.isHidden = false
            print(self.imageView.frame)
            self.cameraButton.isHidden = true
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
