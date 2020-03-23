//
//  ChainProfileCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 3/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension ChainProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           switch section{
           case 0: return masterAuth.currUser.currentChains.count
           default:return 0
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           switch indexPath.section{
           case 0:  //The other chains
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChainCollectionViewCell", for: indexPath) as! ChainCollectionViewCell
               let post = masterAuth.currUser.currentChains[indexPath.row]
               cell.setForChain(_chain: post)
               collViewIndexReference[post.chainUUID] = indexPath
               return cell
               
           default:    //whatever
               return UICollectionViewCell()
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if indexPath.section == 1 { //Bottom
               let chainSelected = masterAuth.currUser.currentChains[indexPath.row]
               let chainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
               chainVC.mainChain = chainSelected
               masterNav.pushViewController(chainVC, animated: true)
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let screen = UIScreen.main.bounds
           let screenWidth = screen.width
           let screenHeight = screen.height
           let width = (screen.width / 2) - 50
           let height = (screenHeight/screenWidth) * width
           
           if indexPath.section == 0{
               return CGSize(width: width, height: height)
           }else{
               return CGSize(width: 200, height: 200)
           }
       }
       
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           switch kind{
           case UICollectionView.elementKindSectionHeader:
               let profileView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainProfileView", for: indexPath) as! MainProfileView
               profileView.setForUser(_user: self.user)
               return profileView
               
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
           return CGSize(width: collectionView.frame.width, height: 300)
       }
}
