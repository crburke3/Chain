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

class ChainViewController: UIViewController, ChainImageDelegate, FloatingPanelControllerDelegate, ChainCameraDelegate, PostChainDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var fanMenu: FanMenu!
    
    var fpc: FloatingPanelController!
    let sendButton = UIButton()
    var mainChain:PostChain!{
        didSet{
            self.mainChain.listenForChanges()
        }
    }
    let cameraVC = CameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSendButton()
        view.bringSubviewToFront(fanMenu)
        cameraVC.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cr.addHeadRefresh(animator: ChainBreakLoader()) {
            self.reloadChain()
        }
        self.reloadChain()
        fanMenuSetUp()
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
        cameraVC.chainID = self.mainChain.chainID //Get chain ID from chain being viewed
        self.present(cameraVC, animated: true)
    }
    
    //Called when the camera view arrow has been tapped
    func didFinishImage(image: UIImage) {
        print("Appending Chain")
        cameraVC.dismiss(animated: true, completion: nil)
        mainChain.append(image: image) { (err, finalImage) in
            if err != nil{ return}  //Will show popups automatically
            print("Chain appended!")
        }
        masterFire.updateFriendsFeed(chainID: mainChain.chainID, userID: "mbrutkow") { (error) in
            if let error = error {
                print("Error updating friend's feed: \(error)")
            }
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
}
