//
//  ChainCollectionViewCell.swift
//  Chain
//
//  Created by Christian Burke on 3/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ChainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    var chain:PostChain!
    
    func setForChain(_chain:PostChain){
        self.chain = _chain
        if chain.loaded == .LOADING || chain.loaded == .NOT_LOADED{
            return
        }
        
        titleLabel.text = chain.chainName
        timerLabel.text = chain.deathDate.timeTillDeath()
        let url = URL(string: chain.firstImageLink ?? "")
        mainImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "fakeImg"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                break//
            case .failure(let error):
                print("Loading chain preview image failed: \(error.localizedDescription)")
            }
        }
    }
    
    func updateTimeLabel(){
        self.timerLabel.text = chain.deathDate.timeTillDeath()
    }
}
