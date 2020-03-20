//
//  UserMenuCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/8/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserMenuCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var selectedIcon: UIView!
    
    var hasBeenSelected: Bool = false
    var user: ChainUser = ChainUser(_username: "", _phoneNumber: "", _name: "")
    
    @IBAction func goToProfile(_ sender: Any) {
        let db = Firestore.firestore()
        let friendVC = ProfileViewController()
        db.collection("users").whereField("phone", isEqualTo: user.phoneNumber)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {print("Error getting documents: \(err)")} else{
                    for document in querySnapshot!.documents {
                        friendVC.user = ChainUser(dict: document.data())
                        masterNav.pushViewController(friendVC, animated: true)
                    }
                }
        }
    }
    
    func cellDidLoad() { //Set up UI
        let url = URL(string: self.user.profile)
        self.userName.text = self.user.username //currentUser.friends[indexPath.index]["user"]
        self.profilePic.kf.setImage(with: url)
        self.profilePic.layer.borderWidth = 1
        self.profilePic.layer.masksToBounds = false
        self.profilePic.layer.borderColor = UIColor.black.cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        self.profilePic.clipsToBounds = true
        self.selectedIcon.layer.borderWidth = 0.5
        self.selectedIcon.layer.masksToBounds = false
        self.selectedIcon.layer.borderColor = UIColor.lightGray.cgColor
        self.selectedIcon.layer.cornerRadius = self.selectedIcon.frame.height/2
        self.selectedIcon.clipsToBounds = true
    }
}
