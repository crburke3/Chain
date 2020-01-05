//
//  ViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ChainImageDelegate {

    var mainChain:PostChain!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        masterFire.loadChain(chainID: "firstChain") { (loadedChain) in
            if let chain = loadedChain{
                self.mainChain = chain
                self.listenToDate()
                for post in self.mainChain.posts{
                    post.delegate = self
                }
                self.tableView.reloadData()
            }
        }

    }
    
    @IBAction func plusClicked(_ sender: Any) {
        //Load Global Object
        let cameraVC = CameraViewController()
        cameraVC.chainID = "firstChain"
        self.show(cameraVC, sender: nil)
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
}

