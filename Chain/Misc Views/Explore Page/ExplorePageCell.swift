//
//  ExplorePageCell.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Kingfisher

class ExplorePageCell: UICollectionViewCell {
    
    @IBOutlet var roundView: RoundView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    var chain: PostChain = PostChain(chainUUID: "1b0LCcjiVh53Kb89xD8Q")
    var deathDate:Date = Date()
    private var loaded = false
    
    func updateTimeLabel(){
        self.timerLabel.text = chain.deathDate.timeTillDeath()
        if chain.isDead{
            timerLabel.textColor = .red
        }
    }
    
    func cellDidLoad(){
        if chain.isDead{
            timerLabel.textColor = .red
        }
        previewImageView.roundCorners(corners: [.allCorners], radius: 5)
        roundView.addShadow()
        titleLabel.text = chain.chainName
        timerLabel.text = chain.deathDate.timeTillDeath()
        let url = URL(string: chain.firstImageLink ?? "")
        previewImageView.kf.setImage(
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
}
