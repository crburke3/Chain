//
//  ChainUser.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation

class ChainUser{
    
    let name:String
    let phoneNumber:String
    let username:String
    var posts:[PostChain] = []
    
    init(_username:String, _phoneNumber:String, _name:String){
        self.phoneNumber = _phoneNumber
        self.username = _username
        self.name = _name
    }
    
    static func initFromFirestore(with phoneNumber:String, user: @escaping(ChainUser?)->()){
        
    }
    
    func toDict() -> [String:Any] { //To be expanded/more detailed later
        return ["name" : self.name, "phone" : self.phoneNumber, "posts" : self.posts, "blocked": []]
    }
    
    
}
