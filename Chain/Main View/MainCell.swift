//
//  MainCollectionViewCell.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import PopupDialog
import FloatingPanel
import Firebase

class MainCell: UITableViewCell, ChainCameraDelegate {
    //var fpc: FloatingPanelController!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var user: UILabel!
    @IBOutlet var backView: RoundView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var infoViewHeight: NSLayoutConstraint!
    @IBOutlet var heartButton: RoundButton!
    
    var phone: String = ""
    var isExpanded = false
    var post: ChainImage!
    var row: Int = 0
    var isPostLoaded = false
    var isLoaded = false
    var cameraVisible = false
    var viewingImageNumber = 1
    
    @IBOutlet weak var optionsMenu: RoundButton!
    
    @IBAction func shareButton(_ sender: Any) {
        //Called on button press
    }
    
    @objc func goToProfile(_ sender: Any) {
        let user = ChainUser(_username: "Not Loaded", _phoneNumber: post.userPhone, _name: "Not Loaded")
        let profileVC = ChainProfileViewController.initFromSB(user: user)
        masterNav.pushViewController(profileVC, animated: true)
        //tabBarController?.selectedIndex = 1
    }
    
    @IBOutlet weak var share: UIButton!
    
    @IBAction func popUpMenu(_ sender: Any) {
        //Center or pass image
        if isPostLoaded{
            
            //Delegate
            /*
            let chainVC = masterNav.findViewController(with: "ChainViewController") as! ChainViewController
            chainVC.showOptionsPopup(post_row: self.row, post_image: self.imgView.image ?? UIImage())
             */
        }
    }
    
    @IBAction func respondToPost(_ sender: Any) {
    }
    
    
    @IBAction func heartTapped(_ sender: Any) {
        heartButton.startSpinner()
        self.post.like { (succ) in
            self.heartButton.stopSpinner()
            if succ{
                self.heartButton.tintColor = UIColor.Chain.mainOrange
            }else{
                self.heartButton.tintColor = .white
            }
        }
    }
    
    func moveExpansion(){
        if isExpanded{
            infoViewHeight.constant = 0
        }else{
            infoViewHeight.constant = 50
        }
        isExpanded = !isExpanded
        UIView.animate(withDuration: 0.5) {
            self.contentView.layoutIfNeeded()
        }
    }
   
    func cellDidLoad(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(sender:)))
        tap.numberOfTapsRequired = 2
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        let heldDown = UILongPressGestureRecognizer(target: self, action: #selector(imgHeldDown(sender:)))
        heldDown.minimumPressDuration = 1.0 //Number of seconds to be held down
        imgView.addGestureRecognizer(heldDown)
        //
        user.text = post.user
        user.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:))))
        user.isUserInteractionEnabled = true
        profilePicImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile(_:))))
        profilePicImage.isUserInteractionEnabled = true
        isExpanded = false
        infoViewHeight.constant = 0
        moveExpansion()
        infoView.clipsToBounds = true
        infoView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
        imgView.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(imgTapped(sender:))))
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(imgDoubleTapped(sender:)))
        doubleGesture.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(doubleGesture)
        self.backView.addShadow()
        //self.profilePicImage.downloadWithHolder(_url: post.link, _placeholder: UIImage(named: "flipCamera")!)
        profilePicImage.downloaded(from: post.userProfile)
        imgView.downloadWithHolder(_url: post.link, _placeholder: UIImage(named: "flipCamera")!)
        self.profilePicImage?.kf.setImage(with: URL(string: post.userProfile)) { result in
            switch result {
            case .success(let value):
                self.profilePicImage?.layer.borderWidth = 1
                self.profilePicImage?.layer.masksToBounds = false
                self.profilePicImage?.layer.borderColor = UIColor.black.cgColor
                self.profilePicImage?.layer.cornerRadius = (self.profilePicImage?.frame.height)!/2
                self.profilePicImage?.clipsToBounds = true
                break
            case .failure(let error):
                self.profilePicImage.image = UIImage(named: "fakeImg")
                print("failed image load: \(self.post.link)")
                //print(error)
            }
        }
        self.profilePicImage?.kf.setImage(with: URL(string: post.link)) { result in
            switch result {
            case .success(let value):
                break
            case .failure(let error):
                self.profilePicImage.image = UIImage(named: "fakeImg")
                print("failed image load: \(self.post.link)")
                //print(error)
            }
        }
    }
    
    @objc func imgDoubleTapped(sender: UIImageView){
        print("double tapped")
    }
    
    @objc func imgHeldDown(sender: UIImageView) {
        if !cameraVisible {
            cameraVisible = true
            print("Responding to post")
            let cameraVC = CameraViewController()
            cameraVC.addDelegate(key: post.uuid, delegate: self)
            cameraVC.chainName = post.parentChain?.chainUUID ?? "" //Get chain ID from chain being viewed
            masterNav.pushViewController(cameraVC, animated: true)
            //Push camera vc
        }
    }
    
    @objc func imgTapped(sender: UIImageView){
        //moveExpansion()
        print("Getting next response")
        viewingImageNumber += 1
        if viewingImageNumber < post.numberOfImagesInPost {
            //
            post.getNextPost { (image) in
                let url = URL(string: image.link)
                self.imgView.kf.setImage(with: url)
            }
        }
        if viewingImageNumber == post.numberOfImagesInPost {viewingImageNumber = 0}
    }
    
    func didFinishImage(image: UIImage) { //Called after photo has been taken
        cameraVisible = false
        print("Appending Chain")
        masterNav.popViewController(animated: true)
        //Create ChainImage
        var urlString = ""
        let data = image.jpegData(compressionQuality: 1.0)!
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("Fitwork Images").child(imageName)
        let metaDataForImage = StorageMetadata() //
        metaDataForImage.contentType = "image/jpeg" //
        
        imageReference.putData(data, metadata: metaDataForImage) { (meta, err1) in //metadata: nil to metaDataForImage
            if err1 != nil {return}
            imageReference.downloadURL(completion: { (url, err2) in
                if err2 != nil {return}
                if url == nil {return}
                urlString = url!.absoluteString //Hold URL
                print(urlString)
                //
                let uploadImage = ChainImage(link: urlString, user: masterAuth.currUser.username, userProfile: masterAuth.currUser.profile, userPhone: masterAuth.currUser.phoneNumber, image: image)
                uploadImage.link = urlString
                let dict = uploadImage.toDict(height: image.size.height, width: image.size.width)
                //Add to responses collection
                //self.post.uuid = "umsIv3SnQolqT6nCCW8o"
                let chainUUID = self.post.parentChain?.chainUUID ?? ""  //"umsIv3SnQolqT6nCCW8o"
                let imageUUID = self.post.uuid //"2OmMp4jbtk1Bie6VEixX"

                masterFire.db.collection("chains").document(chainUUID).collection("posts").document(imageUUID).collection("responses").addDocument(data: dict)
                //Increment parent image counter
                masterFire.db.collection("chains").document(chainUUID).collection("posts").document(imageUUID).updateData(["numberOfImages": FieldValue.increment(Int64(1))])
                //
            })
        }
    }
}
