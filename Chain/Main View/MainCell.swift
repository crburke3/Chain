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
        //Called on button press
        
        
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
            chainVC.showOptionsPopup(post_row: self.row, post_image: self.imgView.image ?? UIImage())
        }
    }
    
    
    func cellDidLoad(){
        self.backView.addShadow()
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
                print(error)
            }
        }
    }
}
