//
//  ChainsCollectionViewCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/15/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Kingfisher

class ChainsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var chainTitle: UILabel!
    @IBOutlet weak var timeTilDeath: UILabel!
    
    var chain = PostChain(chainName: "")
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 6.0
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.layer.masksToBounds = true
              
        
    }
    
    func cellDidLoad() {
        self.mainView.addShadowToUIView()
        self.imagePreview.layer.masksToBounds = true
        self.imagePreview.layer.borderColor = UIColor.black.cgColor
        self.imagePreview.layer.cornerRadius = 5
        self.imagePreview.clipsToBounds = true
        let url = URL(string: chain.firstImageLink ?? "")
        chainTitle.text = chain.chainName
        imagePreview.kf.setImage(
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
    
    func listenToDate(){
        self.chain.deathDate.timeTillDeath { (timeLeft) in
            self.timeTilDeath.text = timeLeft
        }
    }
    

}
