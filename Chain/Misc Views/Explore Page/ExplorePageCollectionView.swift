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
        return topChains.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    }
    
    
}
