//
//  PopupMenuExtension.swift
//  Chain
//
//  Created by Christian Burke on 1/8/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import PopupDialog
import FloatingPanel

extension ChainViewController{
    func showOptionsPopup(post_row: Int, post_image: UIImage){
        let title = "Image Options"
        let message = "Select one of the actions below or press cancel"
        var postUser = ""
        let givenCell = self.tableView.cellForRow(at: IndexPath(row: post_row, section: 0)) as! MainCell
        let givenPost = givenCell.post.toDict() as [String:Any]
        postUser = givenPost["user"] as! String
        let indexPath = NSIndexPath(row: post_row, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        //Resize/Crop
        let image = cropToBounds(image: post_image, width: 200, height: 200)
        let popup = PopupDialog(title: title, message: message, image: image) //Image arguement is optional
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("Canceled")
        }
        let shareButton = DefaultButton(title: "Share Chain from this Image") {
            self.sendButton.isHidden = false
            self.fpc = FloatingPanelController()
            self.fpc.delegate = self // Optional
            let contentVC = masterStoryBoard.instantiateViewController(withIdentifier: "UserMenuTableViewController") as! UserMenuTableViewController
            //Set conentVC array to hold currentUsers friends
            self.fpc.set(contentViewController: contentVC)
            self.fpc.track(scrollView: contentVC.tableView)
            self.fpc.isRemovalInteractionEnabled = true
            self.fpc.addPanel(toParent: self)
            //self.fpc.
            self.view.bringSubviewToFront(self.sendButton)
            //let window :UIWindow = UIApplication.shared.keyWindow!
            //window.addSubview(self.sendButton)
        }

        let reportButton = DefaultButton(title: "Report Image", height: 60) {
            print("Report Image")
            masterFire.reportImage(chainID: self.mainChain.chainID, image: ChainImage(dict: givenPost)!) { (error) in
                if let error = error {
                    print(error)
                } else {
                    //Successfully reported
                }
            }
        }
        let removeButton = DefaultButton(title: "Remove your Image") {
            print("Photo: \(post_row)")
            print("Chain Removed")
            masterFire.removeFromChain(chainID: "firstChain", post: givenPost) { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("Post removed")
                }
            }
            self.tableView.reloadData()
        }
        //
        if postUser == "mbrutkow" {
            popup.addButtons([shareButton, reportButton, removeButton, cancelButton])
        } else {
            popup.addButtons([shareButton, reportButton, cancelButton])
        }
        present(popup, animated: true, completion: nil)
    }
    
    static func initFrom(chain: PostChain)->ChainViewController{
        let vc = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
        vc.mainChain = chain
        return vc
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
 
    func createSendButton(){
        self.sendButton.isHidden = true
        self.sendButton.backgroundColor = .red
        self.sendButton.setTitle("Send", for: .normal)
        tableView.addSubview(self.sendButton)
        // set position
        var X_Position:CGFloat? = 50.0 //use your X position here
        var Y_Position:CGFloat? = 50.0 //use your Y position here
        //sendButton.frame.width = 100.0 as CGFloat
        //sendButton.frame.height = 100.0 as CGFloat
        
        sendButton.frame = CGRect(x: X_Position!, y: Y_Position!, width: sendButton.frame.width, height: sendButton.frame.height)
        
        self.sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true // specify the height of the view
        self.sendButton.backgroundColor = UIColor(displayP3Red: 15/250, green: 239/250, blue: 224/250, alpha: 0.6)
    }
    
}
