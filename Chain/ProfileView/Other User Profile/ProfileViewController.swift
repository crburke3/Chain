//
//  ProfileViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/15/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendButton: RoundButton!
    @IBOutlet weak var userName: UILabel!
    @IBAction func friendAction(_ sender: Any) {
        masterFire.addFriend(friend: ["phone": user.phoneNumber,"profile": user.profile,"username": user.username]) { (error) in
            //
        }
    }
    
    var user = ChainUser(_username: "", _phoneNumber: "", _name: "")
    var isCurrentUser: Bool = false //If set to true, view controller will change to allow user to edit profile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "ChainsCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "ChainsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        //Get profile photo
        profilePic.image = UIImage()
        let url = URL(string: user.profile)
        profilePic.kf.setImage(with: url)
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        userName.text = user.username
        //flowLayout.invalidateLayout()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        print(self.user.name)
        //
        if isFriend() {
            friendButton.setTitle("Remove Friend", for: .normal)
        } else {
            friendButton.setTitle("Add Friend", for: .normal)
        }
    }
    
    //Collection View functions
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.4, height: height * 0.4)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    /*
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 10
        return UIEdgeInsets(top: CGFloat(inset), left: CGFloat(inset), bottom: CGFloat(inset), right: CGFloat(inset))
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Edit cell here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChainsCollectionViewCell", for: indexPath) as! ChainsCollectionViewCell
        cell.imagePreview.image = UIImage()
        //cell.imagePreview.frame.height = collectionView.frame.height
        //cell.imagePreview.frame.width = collectionView.frame.height
        cell.imagePreview.layer.borderWidth = 1
        cell.imagePreview.layer.masksToBounds = false
        cell.imagePreview.layer.borderColor = UIColor.black.cgColor
        cell.imagePreview.layer.cornerRadius = 3
        cell.imagePreview.clipsToBounds = true
        collectionView.collectionViewLayout.collectionViewContentSize.width
        return cell
    }
    
   
    
    
     //Use for interspacing
     func collectionView(_ collectionView: UICollectionView,
         layout collectionViewLayout: UICollectionViewLayout,
         minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
             return 0.0 //1.0
     }

     func collectionView(_ collectionView: UICollectionView, layout
         collectionViewLayout: UICollectionViewLayout,
         minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
             return 0.0 //1.0
     }
     
    func isFriend() -> Bool {
        for friend in masterAuth.currUser.friends {
            if (user.phoneNumber == friend.phoneNumber) {
                return true
            }
        }
        return false
    }
}
