//
//  CurrentUserProfileViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class CurrentUserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Grab info from currentUser
        setUpImage() //Gets profile photo and formats it correctly
        username.text = currentUser.username
        userBio.text = currentUser.bio
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
    
    
    @IBAction func editProfile(_ sender: Any) {
        //Push EditProfileVC
        let editProfileVC = EditProfileViewController()
        masterNav.pushViewController(editProfileVC, animated: true) //Push Profile
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   //
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
