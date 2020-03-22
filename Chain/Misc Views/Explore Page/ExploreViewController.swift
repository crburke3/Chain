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

    @IBAction func goBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionViewA.collectionViewLayout = BouncyLayout(style: .prominent)
        //let collectionViewLayout = collectionViewA.collectionViewLayout as? UICollectionViewFlowLayout
        //collectionViewLayout?.sectionInset = .init(top: 4, left: 24, bottom: 24, right: 24)
        //collectionViewLayout?.invalidateLayout()
        collectionViewA.delegate = self
        collectionViewA.dataSource = self
        masterFire.lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))

        loadUserFeed(returnNumber: 4) { (chains) in
            self.otherChains = chains
            print("Retrieved User Feed")
            self.collectionViewA.reloadData() //A is bottom collection view
        }
        loadGlobalChainsID { (postChains) in
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
    }
    
    func chainDidLoad(chain: PostChain) {
        let chainIndex = collViewIndexReference[chain.chainName]!
        collectionViewA.reloadItems(at: [chainIndex])
    }
    
    func chainGotNewPost(post: ChainImage) {}
    
    @IBAction func addChain(_ sender: Any) {
        masterNav.pushViewController(NewChainViewController(), animated: true)
    }
}
