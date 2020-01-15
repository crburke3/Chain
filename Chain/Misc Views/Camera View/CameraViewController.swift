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
    @IBOutlet var photosButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    let session = CKFPhotoSession()
    var chainID: String = ""
    var delegate:ChainCameraDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        constrainPreviewView()
        previewView.session = session
        cameraButton.isHidden = false
        view.bringSubviewToFront(cameraButton)
        view.bringSubviewToFront(photosButton)
    }
    
    @IBAction func tappedPhotos(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
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
            self.displayEditorWithImage(image: image)
        }) { (error) in
            self.showPopUp(_title: "Error Capturing Image", _message: error.localizedDescription)
        }
    }
    
    func doneEditing(image: UIImage) {
        if delegate != nil{
            delegate?.didFinishImage(image: image); return
        }
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    func displayEditorWithImage(image:UIImage){
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image = image
        //photoEditor.stickers.append(UIImage(named: "sticker" )!)
        photoEditor.hiddenControls = [.share]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
        self.present(photoEditor, animated: true, completion: nil)
    }
    
    func canceledEditing() {
        print("user canceled editor")
    }
}


protocol ChainCameraDelegate{
    func didFinishImage(image: UIImage)
}
