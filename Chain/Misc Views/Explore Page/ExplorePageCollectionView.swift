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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorePageCell", for: indexPath) as! ExplorePageCell
            cell.roundView.addShadow() //Custom function defined in extensions
            let chain = otherChains[indexPath.row]
            if chain.loaded == .LOADED{
                //cell.loadingView.isHidden = true
                if chain.firstImageLink != nil{
                   cell.previewImageView.downloaded(from: chain.firstImageLink!)
                }
                cell.titleLabel.text = chain.chainName
                cell.deathDate = chain.deathDate
                cell.listenToDate()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalChain", for: indexPath) as! ExplorePageCell
            let chain = topChains[indexPath.row]
            if chain.loaded == .LOADED{
                //cell.loadingView.isHidden = true
                if chain.firstImageLink != nil{
                    cell.previewImageView.downloaded(from: chain.firstImageLink!)
                }
                cell.titleLabel.text = chain.chainName
                cell.deathDate = chain.deathDate
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
            masterCache.allChains.insert(chainSelected, at: 0) //Will need to find new way to store chains in cache, perhaps two chain collections, one for explore page and one for viewed ch
            masterNav.pushViewController(chainVC, animated: true)
        }
        
    }
    
}
