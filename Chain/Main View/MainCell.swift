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

class MainCell: UITableViewCell {
    //var fpc: FloatingPanelController!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var user: UILabel!
    @IBOutlet var backView: RoundView!
    @IBOutlet weak var profilePicImage: UIImageView!
    var phone: String = ""
    
    @IBAction func shareButton(_ sender: Any) {
        //Call function on main
        
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        print(phone)
        if phone == currentUser.phoneNumber {
            let profileVC = CurrentUserProfileViewController()
            masterNav.pushViewController(profileVC, animated: true)
        } else {
            let profile = ProfileViewController()
            let db = Firestore.firestore()
            db.collection("users").whereField("phone", isEqualTo: self.phone).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    profile.user = ChainUser(dict: document.data() as [String : Any])
                }
                masterNav.pushViewController(profile, animated: true)
                }
            }
        }
        print("Pushing VC") //
    }
    @IBOutlet weak var profilePic: UIButton!
    
    @IBOutlet weak var share: UIButton!
    
    
    
    var post: ChainImage!
    var row: Int = 0
    var isPostLoaded = false
    
    @IBAction func popUpMenu(_ sender: Any) {
        //Center or pass image
        if isPostLoaded{
            let chainVC = masterNav.findViewController(with: "ChainViewController") as! ChainViewController
            chainVC.showOptionsPopup(post_row: self.row, post_image: self.post!.image!)
        }
    }
    
    func cellDidLoad(){
        profilePicImage.layer.borderWidth = 1
        profilePicImage.layer.masksToBounds = false
        profilePicImage.layer.borderColor = UIColor.black.cgColor
        profilePicImage.layer.cornerRadius = profilePicImage.frame.height/2
        profilePicImage.clipsToBounds = true
        profilePicImage.contentMode = .scaleAspectFill
    }
}
//Load Image? Might need to reload image if post is in cache but not image
//cell.imgView.roundCorners(corners: [.allCorners], radius: 5)
//cell.row = indexPath.row
//cell.post = self.mainChain.posts[indexPath.row]
//let urlProfile = URL(string: self.mainChain.posts[indexPath.row].userProfile)
//cell.profilePicImage?.kf.setImage(with: urlProfile)
//cell.phone = self.mainChain.posts[indexPath.row].userPhone
//cell.share.tag = indexPath.row
//cell.share.addTarget(self, action: #selector(ChainViewController.buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
//cell.backView.addShadow()
