//
//  SingleGlobalChainCollectionViewCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 3/26/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class SingleGlobalChainCollectionViewCell: UICollectionViewCell {
    
    var chain = PostChain(chainUUID: "")
    
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var chainName: UILabel!
    @IBOutlet weak var deathDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellDidLoad() {
        if chain.isDead{
                deathDate.textColor = .red
            }
            previewImage.roundCorners(corners: [.allCorners], radius: 5)
            roundView.addShadow()
            chainName.text = chain.chainName
            deathDate.text = chain.deathDate.timeTillDeath()
            let url = URL(string: chain.firstImageLink ?? "")
            previewImage.kf.setImage(
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


