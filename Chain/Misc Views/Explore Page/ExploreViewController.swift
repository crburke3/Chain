//
//  ExploreViewController.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Firebase
import BouncyLayout

class ExploreViewController: UIViewController, PostChainDelegate {

    @IBOutlet weak var collectionViewA: UICollectionView!
    var topChains:[PostChain] = []
    var otherChains:[PostChain] = [] //Will hold Friend's or Global feed
    var collViewIndexReference:[String:IndexPath] = [:]
    
    enum CurrentlyDisplayedFeed: String {
        case FriendsFeed
        case GeneralFeed
    }
    
    var currentFeed = CurrentlyDisplayedFeed.GeneralFeed //Should be set to FriendsFeed after testing
    
    @IBAction func goBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //ollectionView.register(UINib(nibName: "FeedCell", bundle: .main), forCellWithReuseIdentifier: "feedCell")
        collectionViewA?.register(GlobalChainsCollectionViewCell.self, forCellWithReuseIdentifier: "GlobalChains")
        collectionViewA.delegate = self
        collectionViewA.dataSource = self
        masterFire.lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))

        loadUserFeed(returnNumber: 4) { (chains) in
            for chain in chains{
                chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                masterCache[chain.chainUUID] = chain
            }
            self.otherChains = chains
            print("Retrieved User Feed")
            self.collectionViewA.reloadData() //A is bottom collection view
        }
        loadGlobalChainsID { (postChains) in
            for chain in postChains{
                chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                masterCache[chain.chainUUID] = chain
            }
            self.topChains = postChains
            self.collectionViewA.reloadData() //A is bottom collection view
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            for cell in self.collectionViewA.visibleCells{
                if let castCell = cell as? ExplorePageCell{
                    castCell.updateTimeLabel()
                }
            }
        }
        
        let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
        leftSwipeGest.direction = .left
        collectionViewA.addGestureRecognizer(leftSwipeGest)
        let rightSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
        rightSwipeGest.direction = .right
        collectionViewA.addGestureRecognizer(rightSwipeGest)
    }
    
    @objc func funcForGesture(sender: UISwipeGestureRecognizer){
        changeFeed()
    }
    
    func chainDidLoad(chain: PostChain) {
        if let chainIndex = collViewIndexReference[chain.chainName]{
            //collectionViewA.reloadItemes(at: [chainIndex])
        }else{
            collectionViewA.reloadData()
        }
    }
    
    func chainGotNewPost(post: ChainImage) {}
    func chainDidDie(chain: PostChain) {
        if let chainIndex = collViewIndexReference[chain.chainName]{
            collectionViewA.reloadItems(at: [chainIndex])
        }else{
            collectionViewA.reloadData()
        }
    }
    
    @IBAction func addChain(_ sender: Any) {
        let functions = Functions.functions()
        functions.httpsCallable("helloWorld").call { (resutlt, err) in
            
        }
        masterNav.pushViewController(NewChainViewController(), animated: true)
    }
    
    @IBAction func newChain(_ sender: Any) {
        masterNav.pushViewController(NewChainViewController(), animated: true)
    }
}
