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
    @IBOutlet weak var buttonState: RoundButton!
    
    var givenFriend = ChainUser(_username: "", _phoneNumber: "", _name: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeFriendStatus(_ sender: Any) {
        if buttonState.titleLabel?.text == "Remove" {
            print("Removing Friend")
            currentUser.removeFriend(friend: givenFriend) { (error) in
                if let err = error {
                    print(err)
                } else {
                    print("Removed")
                }
                self.buttonState.setTitle("Add", for: .normal)
            }
            print("exited")
        } else {
            print("Readding Friend")
            currentUser.addFriend(friend: givenFriend) { (error) in
                if let err = error {
                    print(err)
                } else {
                    self.buttonState.setTitle("Remove", for: .normal)
                }
                    self.buttonState.setTitle("Remove", for: .normal)
            }
            
        }
    }
    
    
}
