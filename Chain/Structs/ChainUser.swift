//
//  ChainUser.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import Firebase

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
    var friends:[ChainUser] = [ChainUser]()
    var currentChains:[PostChain] = []
    // let userData = ["blocked": [""], "invites": [[:]], "phone": "", "profilePhoto": "", "topPhotos": [""]] as [String:Any]
    var bio: String = ""
    var loaded:LoadState = .NOT_LOADED
    
    init(_username:String, _phoneNumber:String, _name:String){
        self.phoneNumber = _phoneNumber
        self.username = _username
        self.name = _name
    }
    
    //Use to load profile
    init(_username:String, _phoneNumber:String, _profile:String, _name:String, _bio:String, _topPosts:[[String:Any]]) {
        self.username = _username
        self.phoneNumber = _phoneNumber
        self.profile = _profile
        self.name = _name
        self.bio = _bio
        self.topPosts = _topPosts
        self.loaded = .LOADED
    }
    //Init from doc
    init(dict: [String:Any]) {
        self.username = dict["username"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.phoneNumber = dict["phone"] as? String ?? ""
        self.profile = dict["profilePhoto"] as? String ?? ""
        self.bio = dict["bio"] as? String ?? ""
        self.loaded = .LOADED
        //Current chains will be loaded seperately
    }
        
    static func initFromFirestore(with phoneNumber:String, user: @escaping(ChainUser?)->()){
        let ref = masterFire.db.collection("users").document(phoneNumber)
        ref.getDocument { (snap, err) in
            guard let data = snap?.data() else{user(nil); return}
            user(ChainUser(dict: data))
        }
    }
    
    func toDict() -> [String:Any] { //To be expanded/more detailed later
        return ["name" : self.name, "phone" : self.phoneNumber, "posts" : self.posts, "blocked": []]
    }
    
    func getFriends() {
        let db = Firestore.firestore()
        var userArray = [ChainUser]()
        
        db.collection("users").whereField("phone", isEqualTo: currentUser.phoneNumber).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let dictionary = document.data() as [String : Any]
                userArray.append(ChainUser(dict: dictionary))
            }
            self.friends = userArray
            }
        }
        
    }
    
    func addFriend(friend: ChainUser, error: @escaping (String?)->()) {
        let db = Firestore.firestore()
        var friendRef = db.collection("users").document(currentUser.phoneNumber).collection("friends")
        //friendRef.addDocument(data: friend.toDict())
        friendRef.document(friend.phoneNumber).setData(friend.toDict()) { (error) in
            if let err = error {
                print(error)
                return
            } else {
                //print("Successfully added friend! You and \(friend.username) are now friends.") //
                //currentUser.friends.append(friend)
            }
        }
        friendRef = db.collection("users").document(friend.phoneNumber).collection("friends")
        friendRef.document(currentUser.phoneNumber).setData(currentUser.toDict()) { (error) in
            if let err = error {
                print(error)
            } else {
                print("Successfully added friend! You and \(friend.username) are now friends.") //
                currentUser.friends.append(friend)
            }
        }
    }
    
    func removeFriend(friend: ChainUser, error: @escaping (String?)->()) {
        let db = Firestore.firestore()
        var friendRef = db.collection("users").document(currentUser.phoneNumber).collection("friends")
        friendRef.document(friend.phoneNumber).delete { (error) in
            if let err = error {
                print("Couldn't remove friend")
                return
            } else {
                print("Removed friend")
            }
        }
        friendRef = db.collection("users").document(friend.phoneNumber).collection("friends")
        friendRef.document(currentUser.phoneNumber).delete { (error) in
            if let err = error {
                print("Couldn't remove friend")
            } else {
                var i: Int = 0
                for user in self.friends {
                    if user.phoneNumber == friend.phoneNumber {
                        currentUser.friends.remove(at: i)
                    }
                    i += 1
                }
                print("Removed friend")
            }
        }
    }
    
    func load(error: @escaping(String?)->()){
        if self.loaded == .LOADED{
            error(nil); return
        }
        let ref = masterFire.db.collection("users").document(self.phoneNumber)
        ref.getDocument { (snap, err) in
            guard let dict = snap?.data() else{
                error("failed to load"); return
            }
            guard let _username = dict["username"] as? String,
                   let _name = dict["name"] as? String,
                   let _phoneNumber = dict["phone"] as? String,
                   let _profile = dict["profilePhoto"] as? String,
                   let _bio = dict["bio"] as? String
                else{ error("failed parse"); return }
            self.username = _username
            self.name = _name
            self.phoneNumber = _phoneNumber
            self.profile = _profile
            self.bio = _bio
            self.loaded = .LOADED
            error(nil)
        }
    }
}
