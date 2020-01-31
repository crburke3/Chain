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
            return topChains.count
        } else {
            return otherChains.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewA {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExplorePageCell", for: indexPath) as! ExplorePageCell
            let chain = topChains[indexPath.row]
            if chain.loaded == .LOADED{
                cell.loadingView.isHidden = true
                cell.previewImageView.roundCorners(corners: [.allCorners], radius: 5)
                if chain.firstImageLink != nil{
                           cell.previewImageView.downloaded(from: chain.firstImageLink!)
                }
                cell.titleLabel.text = chain.chainID
                cell.deathDate = chain.deathDate
                //cell.timerLabel.text = chian.
                cell.listenToDate()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalChain", for: indexPath) as! ExplorePageCell
            let chain = otherChains[indexPath.row]
            if chain.loaded == .LOADED{
                cell.loadingView.isHidden = true
                cell.previewImageView.roundCorners(corners: [.allCorners], radius: 5)
                if chain.firstImageLink != nil{
                           cell.previewImageView.downloaded(from: chain.firstImageLink!)
                }
                cell.titleLabel.text = chain.chainID
                cell.deathDate = chain.deathDate
                //cell.timerLabel.text = chian.
                cell.listenToDate()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewA {
            let chainSelected = topChains[indexPath.row]
            let chainVC = ChainViewController()
            chainVC.mainChain = chainSelected
            masterNav.pushViewController(chainVC, animated: true)
        } else {
            let chainSelected = otherChains[indexPath.row]
            let chainVC = ChainViewController()
            chainVC.mainChain = chainSelected
            masterNav.pushViewController(chainVC, animated: true)
        }
        
    }
    
}
