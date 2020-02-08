//
//  ExploreViewController.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, PostChainDelegate {
    
    @IBOutlet weak var collectionViewA: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    @IBOutlet weak var switchFeeds: UIButton!
    
    @IBAction func goBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    @IBAction func switchFeedsAction(_ sender: Any) {
        if switchFeeds.titleLabel?.text == "Switch to Friend's Feed" {
            switchFeeds.setTitle("Switch to Global Feed", for: .normal)
            //Reload bottom collection view
            print("Reloading bottom collection view to show Friend's feed")
            loadUserFeed { (chains) in
                self.topChains = chains
                print("Retrieved User Feed")
                self.collectionViewA.reloadData() //A is bottom collection view
            }
        } else {
            switchFeeds.setTitle("Switch to Friend's Feed", for: .normal)
            //Reload bottom collection view
            print("Reloading bottom collection view to show Global feed")
            loadGlobalChainsID { (chains) in
                self.topChains = chains
                print("Retrieved Global Feed")
                self.collectionViewA.reloadData()
            }
        }
    }
    
    
    var topChains:[PostChain] = []
    var otherChains:[PostChain] = [] //Will hold Friend's or Global feed
    //var friendsChains:[PostChain] = []
    
    var collViewIndexReference:[String:IndexPath] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchFeeds.setTitle("Switch to Global Feed", for: .normal)
        //By default show friend's feed
        collectionViewA.delegate = self
        collectionViewA.dataSource = self
        collectionViewB.dataSource = self
        collectionViewB.delegate = self
        
        loadTopChainIDs { (topChainIDs) in
            var chainCount = 0
            for chainID in topChainIDs{
                let chain = PostChain(chainID: chainID)
                self.collViewIndexReference[chainID] = IndexPath(row: chainCount, section: 0)
                chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                self.topChains.append(chain)
                chainCount += 1
            }
            self.collectionViewA.reloadData()
            
        }
        
        loadGlobalChainsID { (postChains) in
            self.otherChains = postChains
            //chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
            //self.globalChains.append(chain)
            self.collectionViewB.reloadData()
        }
    }
    
    func chainDidLoad(chain: PostChain) {
        let chainIndex = collViewIndexReference[chain.chainID]!
        collectionViewA.reloadItems(at: [chainIndex])
    }
    
    func chainGotNewPost(post: ChainImage) {
        
    }
    
    @IBAction func addChain(_ sender: Any) {
        masterNav.pushViewController(NewChainViewController(), animated: true)
    }
}
