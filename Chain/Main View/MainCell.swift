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
    @IBOutlet var backView: RoundView!
    
    var post: ChainImage!
    var row: Int = 0
    var isPostLoaded = false
    
    @IBAction func popUpMenu(_ sender: Any) {
        //Center or pass image
        if isPostLoaded{
            let chainVC = masterNav.findViewController(with: "ChainViewController") as! ChainViewController
            chainVC.showOptionsPopup(post_row: self.row, post_image: self.post!.image!)
        }
    }
    
    func cellDidLoad(){
        
    }
}
