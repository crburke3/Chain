//
//  ExplorePageCell.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ExplorePageCell: UICollectionViewCell {
    
    @IBOutlet var roundView: RoundView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    var deathDate:Date = Date()
    private var loaded = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !loaded{
            roundView.addShadow()
            roundView.addGradient(colorScheme: .ChainOriginal)
            previewImageView.roundCorners(corners: [.allCorners], radius: 5)
        }

    }
    
    func listenToDate(){
        deathDate.timeTillDeath { (timeLeft) in
            self.timerLabel.text = timeLeft
        }
    }
    
}
