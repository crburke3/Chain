//
//  ChainsCollectionViewCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/15/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ChainsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePreview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
        
    }
    

}
