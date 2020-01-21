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
                        friendVC.user.profile = document.get("profilePhoto") as? String ?? ""
                        friendVC.user.posts = document.get("topPhotos") as? [[String:Any]] ?? [[:]] //Will change to PostChain later if top posts is converted to a subcollection
                        masterNav.pushViewController(friendVC, animated: true)
                    }
                }
        }
    }
    
    
    func cellDidLoad() {
        
    }
}
