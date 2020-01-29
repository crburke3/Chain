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
    var phone: String = ""
    
    
    @IBAction func goToProfile(_ sender: Any) {
        let db = Firestore.firestore()
        let friendVC = ProfileViewController()
        //Should have function to call query
        db.collection("users").whereField("phone", isEqualTo: phone)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //Need top posts, profile pic, bio
                        print("\(document.documentID) => \(document.data())")
                        let username = document.get("username") as? String ?? ""
                        let phoneNumber = document.get("phone") as? String ?? ""
                        let profile = document.get("profilePhoto") as? String ?? ""
                        let name = document.get("name") as? String ?? ""
                        let bio = document.get("bio") as? String ?? ""
                        let topPosts = document.get("topPosts") as? [[String:Any]] ?? [[:]]
                        let showUser = ChainUser(_username: username, _phoneNumber: phoneNumber, _profile: profile, _name: name, _bio: bio, _topPosts: topPosts)
                        friendVC.user = showUser
                        masterNav.pushViewController(friendVC, animated: true)
                        
                    }
                }
        }
    }
    
    
    func cellDidLoad() {
        
    }
}
