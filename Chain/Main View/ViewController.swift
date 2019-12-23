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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        masterFire.loadChain(chainID: "firstChain") { (loadedChain) in
            if let chain = loadedChain{
                self.mainChain = chain
                for post in self.mainChain.posts{
                    post.delegate = self
                }
                self.tableView.reloadData()
            }
        }
        // Do anjhjhhhhy additional setup after loading the view.
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        //Load Global Object
        let cameraVC = CameraViewController()
        cameraVC.chainID = "firstChain" //Get chain ID from chain being viewed
        self.show(cameraVC, sender: nil)
    }
    
    func imageDidLoad(chainImage: ChainImage) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: chainImage.localIndex, section: 0)], with: .fade)
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

