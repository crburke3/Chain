//
//  UserMenuCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/8/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class UserMenuCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var hasBeenSelected: Bool = false
    
    func cellDidLoad() {
        
    }
}
