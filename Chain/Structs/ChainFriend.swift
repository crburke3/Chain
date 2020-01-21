//
//  ChainFriend.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/20/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation

class ChainFriend {
    var phone: String = ""
    var username: String = ""
    var profilePic: String = ""
    
    init(phone: String, username: String, profilePic: String) {
        self.phone = phone
        self.username = username
        self.profilePic = profilePic
    }
    
    init() {
        self.phone = ""
        self.username = ""
        self.profilePic = ""
    }
    
    //Save friends list to phone
}
