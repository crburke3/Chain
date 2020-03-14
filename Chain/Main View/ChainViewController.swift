//
//  ViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import PopupDialog
import FloatingPanel
import FanMenu
import Kingfisher
import Firebase

//import SideMenuSwift

class ChainViewController: UIViewController, ChainImageDelegate, FloatingPanelControllerDelegate, ChainCameraDelegate, PostChainDelegate {

    var lastDoc: QueryDocumentSnapshot?
    var nextQuery: Query?
    var counter: Int = 0 //Remove
    var chainSource = "" //Should be either Global or Regular
    let loadRadius: Int = 3 //Once x rows away from bottom of loaded posts, begin loading a new one
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var profileButton: UIButton!
    @IBAction func profileActions(_ sender: Any) {
        //Push currentUser Profile VC
        let currentUserProfileVC = CurrentUserProfileViewController()
        masterNav.pushViewController(currentUserProfileVC, animated: true) //Push Profile
        
    }
    @IBOutlet weak var profileView: UIImageView!
    
  
    var fpc: FloatingPanelController!
    let sendButton = UIButton()
    var mainChain:PostChain!{
        didSet{
            self.mainChain.listenForChanges()
        }
    }
    let cameraVC = CameraViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainChain.posts.last?.loadState = .LOADING
        self.tableView.reloadData() //Reload rows and scroll to bottom returning from posting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainChain.loadPost(postSource: chainSource) { (post) in //chainSource -> global or general
            if self.mainChain.posts.count == 0 {
                self.mainChain.posts.append(post)
                //self.mainChain.posts[0].widthImage = 400
                //self.mainChain.posts[0].heightImage = 400
                self.tableView.reloadData()
            }
        }
        fanMenuSetUp()
        view.bringSubviewToFront(fanMenu)
        cameraVC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cr.addHeadRefresh(animator: ChainBreakLoader()) {
            self.reloadChain()
        }
        self.reloadChain()
        let url = URL(string: currentUser.profile ?? "")
        profileView.kf.setImage(with: url)
        profileView.layer.borderWidth = 1
        profileView.layer.masksToBounds = false
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.cornerRadius = profileView.frame.height/2
        profileView.clipsToBounds = true
        profileView.contentMode = .scaleAspectFill
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the views managed by the `FloatingPanelController` object from self.view.
        if fpc != nil {
            fpc.removePanelFromParent(animated: true)
        }
        sendButton.isHidden = true
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        //Load Global Object
        cameraVC.chainName = self.mainChain.chainName //Get chain ID from chain being viewed
        //self.present(cameraVC, animated: true)
        masterNav.pushViewController(cameraVC, animated: true)
    }
    
    //Called when the camera view arrow has been tapped
    func didFinishImage(image: UIImage) {
        print("Appending Chain")
        mainChain.append(image: image, source: self.chainSource) { (err, finalImage) in
            if err != nil{ return}  //Will show popups automatically
        }
        
    }
    
    func imageDidLoad(chainImage: ChainImage) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: chainImage.localIndex, section: 0)], with: .fade)
        }
    }
    
    func chainGotNewPost(post: ChainImage) {
        tableView.insertRows(at: [IndexPath(row: post.localIndex, section: 0)], with: .automatic)
    }
    
    func chainDidLoad(chain: PostChain) {}
    
    @objc func buttonClicked(sender:UIButton) {
        //ViewController.swift
        //
        let buttonRow = sender.tag
        print(sender.tag)
        self.fpc = FloatingPanelController()
        self.fpc.delegate = self // Optional
        let contentVC = masterStoryBoard.instantiateViewController(withIdentifier: "UserMenuTableViewController") as! UserMenuTableViewController
        contentVC.invitation = Invite(_chainName: mainChain.chainName, _chainPreview: mainChain.firstImageLink ?? "", _dateSent: "", _expirationDate: mainChain?.deathDate.toChainString() ?? "", _sentByUsername: currentUser.username, _sentByPhone: currentUser.phoneNumber, _sentByProfile: currentUser.profile, _receivedBy: "", _index: buttonRow)
        contentVC.index = buttonRow
        contentVC.chain = mainChain.chainName
        contentVC.userArray = currentUser.friends
        //Set conentVC array to hold currentUsers friends
        self.fpc.set(contentViewController: contentVC)
        self.fpc.track(scrollView: contentVC.tableView)
        self.fpc.isRemovalInteractionEnabled = true
        self.fpc.addPanel(toParent: self)
    }
}
