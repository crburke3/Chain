//
//  ExplorePageCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewA {
            return otherChains.count //Something is wrong here and below
        } else {
            return topChains.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewA {
            if (self.otherChains.count - (self.collectionViewA.indexPathsForVisibleItems.last?.row ?? 0) == 2) { //At bottom of feed so load more chains
                loadUserFeed(returnNumber: 2) { (chainArray) in
                    if chainArray.count > 0 {
                        print("Loading 2 more chains after index \(String(describing: self.collectionViewA.indexPathsForVisibleItems.last?.row))")
                        let firstChain = chainArray[0]
                        self.otherChains.append(firstChain)
                        self.otherChains.last?.loaded = .LOADED
                        if chainArray.count == 2 {
                            let secondChain = chainArray[1]
                            self.otherChains.append(secondChain)
                            self.otherChains.last?.loaded = .LOADED
                        }
                        self.collectionViewA.reloadData()
                    }
                }
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorePageCell", for: indexPath) as! ExplorePageCell
            cell.roundView.addShadow() //Custom function defined in extensions
            if otherChains[indexPath.row].loaded == .LOADED {
                cell.chain = otherChains[indexPath.row]
                cell.cellDidLoad()
                cell.titleLabel.text = otherChains[indexPath.row].chainName
                cell.deathDate = otherChains[indexPath.row].deathDate
                cell.listenToDate()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalChain", for: indexPath) as! ExplorePageCell
            if otherChains.count < indexPath.row{return UICollectionViewCell()}
            if otherChains[indexPath.row].loaded == .LOADED {
                cell.chain = otherChains[indexPath.row]
                cell.cellDidLoad()
                cell.titleLabel.text = otherChains[indexPath.row].chainName
                cell.deathDate = otherChains[indexPath.row].deathDate
                cell.listenToDate()
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewA { //Bottom
            let chainSelected = otherChains[indexPath.row]
            let chainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
            chainVC.mainChain = chainSelected
            chainVC.chainSource = "general" //Need to switch to enum
            //Ways to remove interdependencies from VC to VC
            masterCache.allChains.insert(chainSelected, at: 0) //Will need to find new way to store chains in cache, perhaps two chain collections, one for explore page and one for viewed ch

            masterNav.pushViewController(chainVC, animated: true)
        } else {
            let chainSelected = topChains[indexPath.row]
            //let chainVC = ChainViewController()
            let chainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
            chainVC.mainChain = chainSelected
            chainVC.chainSource = "global"
            
            //if doesn't have chain
            masterCache.allChains.insert(chainSelected, at: 0) //Will need to find new way to store chains in cache, perhaps two chain collections, one for explore page and one for viewed ch
            masterNav.pushViewController(chainVC, animated: true)
        }
        
    }
    
}
