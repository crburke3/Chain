//
//  ChainUser.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation

class ChainUser{
    
    var name:String
    var phoneNumber:String
    var username:String
    var posts:[[String:Any]] = [[:]]
    //var posts:[PostChain] = []
    var blocked:[String] = [""]
    var invites:[[String:Any]] = [[:]] //Use invite object and sub-collection for invites
    var topPosts:[[String:Any]] = [[:]] //Use chain objects and sub-collection for posts
    var profile:String = ""
    var friends:[ChainFriend] = [] //Only to be used for currentUser
    // let userData = ["blocked": [""], "invites": [[:]], "phone": "", "profilePhoto": "", "topPhotos": [""]] as [String:Any]
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
