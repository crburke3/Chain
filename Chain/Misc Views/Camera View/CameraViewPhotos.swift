//
//  CameraViewPhotos.swift
//  Chain
//
//  Created by Christian Burke on 1/15/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import CameraKit_iOS

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            self.displayEditorWithImage(image: pickedImage)
        }else{
            self.showPopUp(_title: "Error Selecting Image", _message: "something is super ugly bout that pic")
        }
    }
    
    func constrainPreviewView(){
        previewView = CKFPreviewView(frame: view.bounds)
        previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //view.autoresizesSubviews = true
        view.addSubview(previewView)
        //previewView.pinEdges(to: view)
    }
    
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
