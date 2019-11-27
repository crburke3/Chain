//
//  ChainUser.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation

class ChainUser{
    
    let phoneNumber:String
    let username:String
    var posts:[PostChain] = []
    
    init(_username:String, _phoneNumber:String){
        self.phoneNumber = _phoneNumber
        self.username = _username
    }
    
    static func initFromFirestore(with phoneNumber:String, user: @escaping(ChainUser?)->()){
        
    }
    
    
    
}
