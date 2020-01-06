//
//  MainCollectionViewCell.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import PopupDialog

class MainCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var user: UILabel!
    
    var row: Int = 0
    
    @IBAction func popUpMenu(_ sender: Any) {
        //Center or pass image
        globalRow = self.row
        globalImage = self.imgView.image ?? UIImage()
    }
    
    func cellDidLoad(){
        
    }
    
    
}
