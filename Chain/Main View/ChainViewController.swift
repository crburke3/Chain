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
class ChainViewController: UIViewController, ChainImageDelegate, FloatingPanelControllerDelegate {

    var fpc: FloatingPanelController!
    let sendButton = UIButton()
    var mainChain:PostChain!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var fanMenu: FanMenu!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSendButton()
        view.bringSubviewToFront(fanMenu)
        tableView.delegate = self
        tableView.dataSource = self
        mainChain.load { (err) in
            if err != nil{
                print(err!); return
            }
            self.listenToDate()
            for post in self.mainChain.posts{
                post.delegate = self
            }
            self.tableView.reloadData()
        }
        //
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
        let cameraVC = CameraViewController()
        cameraVC.chainID = self.mainChain.chainID //Get chain ID from chain being viewed
        self.present(cameraVC, animated: true)
    }
    
    func imageDidLoad(chainImage: ChainImage) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: chainImage.localIndex, section: 0)], with: .fade)
        }
    }
    
    func listenToDate(){
        mainChain.deathDate.timeTillDeath { (timeLeft) in
            self.timerLabel.text = timeLeft
        }
    }

    func nextFewImages(chainID: String, currentIndex: Int, loadRadius: Int) {
        //indexPathsForVisibleItems -> Collection View
        //indexPathsForVisibleRow -> Table View
        let upperIndex = currentIndex + loadRadius
        var newIndex = currentIndex + 1
        while (newIndex < upperIndex) {
            //KingFisher load function
            newIndex += 1
        }
    }
    
    func fanMenuSetUp() {
        fanMenu.button = FanMenuButton(id: "Main", image: "infinity", color: .red)
        fanMenu.interval = (0, -(Double.pi)) //In radians
        fanMenu.menuBackground = .clear
        fanMenu.layer.backgroundColor = UIColor.clear.cgColor
        fanMenu.backgroundColor = UIColor.clear
        //May add append chain
        fanMenu.items = [
            FanMenuButton(
                id: "jumpToEnd",
                image: "end",
                color: .green
            ),
            FanMenuButton(
                id: "jumpToRandom",
                image: "random",
                color: .blue
            ),
            FanMenuButton(
                id: "jumpToNextFriendsPost",
                image: "friends",
                color: .teal
            )
        ]
    }
    
}
