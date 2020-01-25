//
//  FriendTableViewCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/24/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeFriendStatus(_ sender: Any) {
        print("Removing Friend")
    }
    
    
}
