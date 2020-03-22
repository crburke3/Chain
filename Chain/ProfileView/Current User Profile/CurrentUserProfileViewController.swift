//
//  CurrentUserProfileViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Firebase

class CurrentUserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentChains = [PostChain]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Grab info from currentUser
        collectionView.register(UINib(nibName: "ChainsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ChainsCollectionViewCell")
        setUpImage() //Gets profile photo and formats it correctly
        username.text = currentUser.username
        userBio.text = currentUser.bio
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        getCurrentChains()
        self.collectionView.reloadData()
    }
    
    func getCurrentChains() {
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.phoneNumber).collection("currentChains").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.currentChains.append(PostChain(dict: document.data())!)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { //Called after child view controller is popped from stack
        let url = URL(string: currentUser.profile)
        self.profilePic.kf.setImage(with: url)
        /* profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
         */
    }
    
    @IBAction func signOut(_ sender: Any) {
        currentUser = ChainUser(_username: "", _phoneNumber: "", _name: "")
        let signInVC = SignInViewController()
        masterNav.pushViewController(signInVC, animated: true)
        
    }
    
    @IBAction func editProfile(_ sender: Any) {
        //Push EditProfileVC
        let editProfileVC = EditProfileViewController()
        masterNav.pushViewController(editProfileVC, animated: true) //Push Profile
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewInvites(_ sender: Any) {
        let inviteVC = InvitesViewController()
        masterNav.pushViewController(inviteVC, animated: true)
    }
    
    
    
   //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return currentChains.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

         let height = view.frame.size.height
         let width = view.frame.size.width
         // in case you you want the cell to be 40% of your controllers view
         return CGSize(width: width * 0.4, height: height * 0.4)
     }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
     
     
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         //Edit cell here
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChainsCollectionViewCell", for: indexPath) as! ChainsCollectionViewCell
         cell.chain = currentChains[indexPath.row]
         cell.cellDidLoad()
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

}

extension CurrentUserProfileViewController {
    func setUpImage() {
        let url = URL(string: currentUser.profile)
        profilePic.kf.setImage(with: url)
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
}
