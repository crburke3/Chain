//
//  ExplorePageCell.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ExplorePageCell: UICollectionViewCell {
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    var deathDate:Date = Date()
    
    override func layoutSubviews() {

    }
    
    func listenToDate(){
        deathDate.timeTillDeath { (timeLeft) in
            self.timerLabel.text = timeLeft
        }
    }
    
}
