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
import ParallaxHeader
import UIScrollView_InfiniteScroll

//import SideMenuSwift

class ChainViewController: UIViewController, ChainImageDelegate, FloatingPanelControllerDelegate, ChainCameraDelegate, PostChainDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var fanMenu: FanMenu!
    
    let imageView = UIImageView()
    let userHeader = UserHeaderView(frame: .zero)
    var fpc: FloatingPanelController!
    let sendButton = UIButton()
    let cameraVC = CameraViewController()
    var lastDoc: QueryDocumentSnapshot?
    var nextQuery: Query?
    var counter: Int = 0 //Remove
    let loadRadius: Int = 3 //Once x rows away from bottom of loaded posts, begin loading a new one
    var mainChain:PostChain = masterCache["1b0LCcjiVh53Kb89xD8Q"]{
        didSet{
            self.mainChain.addDelegate(delegateID: "ChainViewController", delegate: self)
            self.mainChain.listenForChanges()
            self.mainChain.load { (err) in }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainChain.posts.last?.loadState = .LOADING
        self.tableView.reloadData() //Reload rows and scroll to bottom returning from posting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mainChain.loaded == .LOADED{chainDidLoad(chain: mainChain)}
        titleLabel.text = mainChain.chainName
//        mainChain.loadPost() { (post) in //chainSource -> global or general
//            if self.mainChain.posts.count == 0 {
//                self.mainChain.localAppend(post: post)
//                self.tableView.reloadData()
//            }
//        }
        fanMenuSetUp()
        view.bringSubviewToFront(fanMenu)
        setupTableView()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.timerLabel.text = self.mainChain.deathDate.timeTillDeath()
        }
        
        tableView.addInfiniteScroll { (tableview) in
            self.loadMorePosts()
        }
        loadMorePosts()
    }
    
    func loadMorePosts(){
        let prevCount = mainChain.posts.count
        mainChain.loadPosts(count: 5) { (posts) in
            self.tableView.reloadData()
            var indexes:[IndexPath] = []
            var newCount = prevCount
            for post in posts{
                if newCount < posts.count{
                    indexes.append(IndexPath(row: newCount, section: 0))
                    newCount += 1
                }
            }
            if prevCount == 0{
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: prevCount, section: 0), at: .middle, animated: false)
                //self.reloadTableView(self.tableView)
            }else{
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: prevCount, section: 0), at: .bottom, animated: false)
//                self.tableView.beginUpdates()
//                self.tableView.insertRows(at: indexes, with: .bottom)
//                self.tableView.endUpdates()
                //self.reloadTableView(self.tableView)
            }
            self.tableView.finishInfiniteScroll(completion: nil)
        }
    }
    
    func reloadTableView(_ tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }

    func setupTableView(){
        cameraVC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self


        tableView.parallaxHeader.view = userHeader
        tableView.parallaxHeader.height = 100
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .bottomFill
        userHeader.likesLabel.text = "likes: \(mainChain.likes)"
        userHeader.commentLabel.text = "comments: \(25)"
        tableView.parallaxHeader.view.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            let progress = parallaxHeader.progress
            let height = self.userHeader.bounds.height
            if parallaxHeader.progress > 1 && parallaxHeader.progress < 1.5{
                print(progress)
                self.userHeader.likesLabel.alpha = (progress - 1.0) * 2
                self.userHeader.commentLabel.alpha = (progress - 1.0) * 2
                self.userHeader.nameHeight.constant = (progress - 1.0) * 50
                self.userHeader.commentHeight.constant = (progress - 1.0) * 50
                self.userHeader.likesHeight.constant = (progress - 1.0) * 50
                self.userHeader.imgView.roundCorners(corners: [.allCorners], radius: height/2)
                self.tableView.backgroundColor = self.userHeader.contentView.backgroundColor
            }
        }
        //tableView.parallaxHeader..layoutIfNeeded()
        
        tableView.cr.addHeadRefresh(animator: ChainBreakLoader()) { self.reloadChain() }
        tableView.cr.header!.frame = tableView.cr.header!.frame.offsetBy(dx: 0, dy: -130)
        self.reloadChain()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the views managed by the `FloatingPanelController` object from self.view.
        if fpc != nil { fpc.removePanelFromParent(animated: true) }
        sendButton.isHidden = true
    }
    
    @IBAction func back(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        cameraVC.chainName = self.mainChain.chainName //Get chain ID from chain being viewed
        masterNav.pushViewController(cameraVC, animated: true)
    }
    
    //Called when the camera view arrow has been tapped
    func didFinishImage(image: UIImage) {
        print("Appending Chain")
        mainChain.append(image: image) { (err, finalImage) in
            if err != nil{ return}  //Will show popups automatically
        }
        
    }
    
    func imageDidLoad(chainImage: ChainImage) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: chainImage.localIndex, section: 0)], with: .fade)
        }
    }
    
    @objc func buttonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        print(sender.tag)
        self.fpc = FloatingPanelController()
        self.fpc.delegate = self // Optional
        let contentVC = masterStoryBoard.instantiateViewController(withIdentifier: "UserMenuTableViewController") as! UserMenuTableViewController
        contentVC.invitation = Invite(_chainName: mainChain.chainName, _chainPreview: mainChain.firstImageLink ?? "", _dateSent: "", _expirationDate: mainChain.deathDate.toChainString() ?? "", _sentByUsername: currentUser.username, _sentByPhone: currentUser.phoneNumber, _sentByProfile: currentUser.profile, _receivedBy: "", _index: buttonRow)
        contentVC.index = buttonRow
        contentVC.chain = mainChain.chainName
        contentVC.userArray = currentUser.friends
        //Set conentVC array to hold currentUsers friends
        self.fpc.set(contentViewController: contentVC)
        self.fpc.track(scrollView: contentVC.tableView)
        self.fpc.isRemovalInteractionEnabled = true
        self.fpc.addPanel(toParent: self)
    }
    
    func chainGotNewPost(post: ChainImage) {
        tableView.insertRows(at: [IndexPath(row: post.localIndex, section: 0)], with: .automatic)
    }
    
    func chainDidLoad(chain: PostChain) {
        titleLabel.text = mainChain.chainName
        tableView.reloadData()
        userHeader.setForChain(chain: chain)
    }
    
    
    func chainDidDie(chain: PostChain) {
        
    }
}
