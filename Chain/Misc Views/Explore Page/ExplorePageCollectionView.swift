//
//  ExplorePageCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0: return 1 //Return one cell
        case 1: return otherChains.count //Something is wrong here and below
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0: //Top Chains
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalChains", for: indexPath) as! GlobalChainsCollectionViewCell
            /*
            if topChains[indexPath.row].loaded == .LOADED {
                cell.chain = topChains[indexPath.row]
                cell.cellDidLoad()
            }
             */
            cell.chainArray = topChains
            cell.globalChainsLoaded()
            return cell
        
        case 1:  //The other chains
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
                let chain = otherChains[indexPath.row]
                cell.chain = chain
                cell.cellDidLoad()
            }
            return cell
            
        default:    //whatever
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { //Bottom
            let chainSelected = otherChains[indexPath.row]
            masterCache.allChains.insert(chainSelected, at: 0) //Will need to find new way to store chains in cache, perhaps two chain collections, one for explore page and one for viewed ch
            
            masterNav.pushViewController(chainSelected.viewController, animated: true)
        } else {
            let chainSelected = topChains[indexPath.row]
            //let chainVC = ChainViewController()
            let chainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
            chainVC.mainChain = chainSelected
            masterCache.allChains.insert(chainSelected, at: 0) //Will need to find new way to store chains in cache, perhaps two chain collections, one for explore page and one for viewed ch
            masterNav.pushViewController(chainSelected.viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds
        let screenWidth = screen.width
        let screenHeight = screen.height
        let width = (screen.width / 2) - 10
        let height = (screenHeight/screenWidth) * width
        
        if indexPath.section == 1{
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: screenWidth, height: screenWidth/3)

        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ExploreHeaderReusableView", for: indexPath) as! ExploreHeaderReusableView
            var text:String!
            switch indexPath.section{
            case 0: text = "Top Chains"
            case 1: text = "Other Chains"
            default: text = "N/A"
            }
            if headerView.headerLabel != nil{
                headerView.headerLabel.text = text
            }
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ExploreHeaderReusableView", for: indexPath) as! ExploreHeaderReusableView
            headerView.backgroundColor = .yellow
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
}
