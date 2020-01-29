//
//  InviteTableViewCell.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/26/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {

    @IBOutlet weak var chainView: UIView!
    @IBOutlet weak var chainPreview: UIImageView!
    @IBOutlet weak var chainTitle: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var sendersProfilePic: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    var invitation: Invite = Invite(_chainID:"", _chainPreview:"", _dateSent:"", _expirationDate:"", _sentByUsername:"", _sentByPhone: "", _sentByProfile:"", _receivedBy:"", _index: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chainView.layer.cornerRadius = 4
        chainView.layer.masksToBounds = true
        sendersProfilePic.layer.borderWidth = 1
        sendersProfilePic.layer.masksToBounds = false
        sendersProfilePic.layer.borderColor = UIColor.black.cgColor
        sendersProfilePic.layer.cornerRadius = sendersProfilePic.frame.height/2
        sendersProfilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func dismissInvite(_ sender: Any) {
        print("Dismiss/Remove Invite") //
    }
    
}
