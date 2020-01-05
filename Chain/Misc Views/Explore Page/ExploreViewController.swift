//
//  ExploreViewController.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, PostChainDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    var topChains:[PostChain] = []
    var collViewIndexReference:[String:IndexPath] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadTopChainIDs { (topChainIDs) in
            var chainCount = 0
            for chainID in topChainIDs{
                let chain = PostChain(chainID: chainID)
                self.collViewIndexReference[chainID] = IndexPath(row: 0, section: chainCount)
                chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                self.topChains.append(chain)
                chainCount += 1
            }
            self.collectionView.reloadData()
        }
    }
    
    func chainDidLoad(chain: PostChain) {
        let chainIndex = collViewIndexReference[chain.chainID]!
        collectionView.reloadItems(at: [chainIndex])
    }
}
