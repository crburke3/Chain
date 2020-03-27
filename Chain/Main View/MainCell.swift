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
    @IBOutlet var infoView: UIView!
    @IBOutlet var infoViewHeight: NSLayoutConstraint!
    @IBOutlet var heartButton: RoundButton!
    
    var phone: String = ""
    var isExpanded = false
    var post: ChainImage!
    var row: Int = 0
    var isPostLoaded = false
    
    @IBOutlet weak var optionsMenu: RoundButton!
    
    @IBAction func shareButton(_ sender: Any) {
        //Called on button press
    }
    
    @objc func goToProfile(_ sender: Any) {
        let user = ChainUser(_username: "Not Loaded", _phoneNumber: post.userPhone, _name: "Not Loaded")
        let profileVC = ChainProfileViewController.initFromSB(user: user)
        masterNav.pushViewController(profileVC, animated: true)
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
            infoViewHeight.constant = 100
        }
        isExpanded = !isExpanded
        UIView.animate(withDuration: 0.5) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    
    func cellDidLoad(){
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
    
    @objc func imgTapped(sender: UIImageView){
        moveExpansion()
    }
}
