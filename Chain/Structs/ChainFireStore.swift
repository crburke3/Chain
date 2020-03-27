//
//  File.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import CoreLocation
//import Geofirestore
import Firebase
import FirebaseFirestore

class ChainFireStore {
    //
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    var allChains:[PostChain] = []
    var lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))
    

    //If error comes back as nil, then nothing went wrong
    func removeFromChain(chainName: String, post:[String:Any], completion: @escaping (String?)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("chains").document(chainName)
        firestoreRef.updateData([
            "posts": FieldValue.arrayRemove([post]), "count": FieldValue.increment(Int64(1))
        ])
        
    }
    
    
    func addFriend(friend: [String:Any], error: @escaping (String?)->()) {
        //Add other user to current user's friend list
        let currentUserBasicInfo = ["phone": masterAuth.currUser.phoneNumber, "profile": masterAuth.currUser.profile, "username": masterAuth.currUser.username] as [String:Any]
        var firestoreRef = Firestore.firestore().collection("users").document(masterAuth.currUser.phoneNumber)
        firestoreRef.updateData([
            "friends": FieldValue.arrayUnion([friend])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error adding friend to your friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
        //Add current user to other user's friends list
        firestoreRef = Firestore.firestore().collection("users").document(friend["phone"] as? String ?? "")
        firestoreRef.updateData([
            "friends": FieldValue.arrayUnion([masterAuth.currUser])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error adding you to friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
    }
    
    func removeFriend(friend: [String:Any], error: @escaping (String?)->()) {
        let currentUserBasicInfo = ["phone": masterAuth.currUser.phoneNumber, "profile": masterAuth.currUser.profile, "username": masterAuth.currUser.username] as [String:Any]
        var firestoreRef = Firestore.firestore().collection("users").document(masterAuth.currUser.phoneNumber)
        firestoreRef.updateData([
            "friends": FieldValue.arrayRemove([friend])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error removing friend from your friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
        //Add current user to other user's friends list
        firestoreRef = Firestore.firestore().collection("users").document(friend["phone"] as? String ?? "")
        firestoreRef.updateData([
            "friends": FieldValue.arrayRemove([masterAuth.currUser])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error removing you from friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
    }
    
    func signUpUser(docData: [String : Any], error: @escaping (String?)->()) {
        Firestore.firestore().collection("users").document(docData["username"] as! String).setData(docData) { err in
            if let err = err {
                masterNav.showPopUp(_title: "Error creating account!", _message: err.localizedDescription)
                error(err.localizedDescription)
            } else {
                error(nil)
            }
        }
        

    }
    
    func blockUser(currentUser: String, blockUser: String, error: @escaping (String?)->()) {
        let firestoreRef = Firestore.firestore().collection("users").document(currentUser)
        firestoreRef.updateData([
            "blocked": FieldValue.arrayUnion([blockUser])
        ]) { (err1) in
            if let error1 = err1{
                masterNav.showPopUp(_title: "Error blocking user", _message: error1.localizedDescription)
                error(error1.localizedDescription)
            }else{
                error(nil)
            }
        }
        
    }
    
    
    func inviteFriend(chainName: String, sendUser: String, index: Int, error: @escaping (String?)->()) {
        //In Invitation object for now
        
        
    }
    func getCurrentUsersData(phone: String, error: @escaping (String?)->()) {
        //When user signs in, gather their data
        db.collection("users").whereField("phone", isEqualTo: phone).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                error(err.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    //currentUser.friends = document.get("friends") as? [[String:Any]] ?? [[:]]
                    let blocked = document.get("blocked") as? [String] ?? [""]
                    let invites = document.get("invites") as? [[String:Any]] ?? [[:]]
                    let phone = document.get("phone") as? String ?? ""
                    let profilePhoto = document.get("profilePhoto") as? String ?? ""
                    let topPhotos = document.get("topPhotos") as? [[String:Any]] ?? [[:]]
                    masterAuth.currUser.bio = document.get("bio") as? String ?? ""
                    masterAuth.currUser.name = document.get("name") as? String ?? ""
                    masterAuth.currUser.username = document.get("username") as? String ?? ""
                    masterAuth.currUser.blocked = blocked
                    masterAuth.currUser.invites = invites
                    masterAuth.currUser.phoneNumber = phone
                    masterAuth.currUser.profile = profilePhoto
                    masterAuth.currUser.topPosts = topPhotos
                    //Need to save chains, friends, and blocked as well
                    
                }
                masterAuth.currUser.getFriends()
                error(nil)
            }
        }
    }
    
    func updateFriendsFeed(chain: PostChain, error: @escaping (String?)->()) {
        //userID = phone number
        for user in masterAuth.currUser.friends {
            let postRef = db.collection("userFeeds").document(user.phoneNumber).collection("feed")
            postRef.document(chain.chainUUID).setData(chain.toDict()) { (error) in if let err = error {print(err.localizedDescription)} else {
                    //Consider only uploading to top friends
                }
            }
        }
        //Add chain to Current Chains
        let currentUserRef = db.collection("users").document(masterAuth.currUser.phoneNumber).collection("currentChains")
        currentUserRef.document(chain.chainUUID).setData(chain.toDict()) { (error) in if let err = error {print(err.localizedDescription)} else {
                //Consider only uploading to top friends
            }
        }
    }
    
    func loadNextFewPhotos() {
        
    }
    
    func reportImage(chainName: String, image: ChainImage, error: @escaping (String?)->()) {
        //Create and upload doc
        var ref: DocumentReference? = nil
        ref = db.collection("reportedPosts").addDocument(data: image.toDict(height: image.heightImage, width: image.widthImage)) { err in
            if let err = err {
                print("Error Reporting: \(err)")
            } else {
                print("Successfully Reported: \(ref!.documentID)")
            }
        }
        
    }
    
    func shareChain(chainName: String, sender: ChainUser, receivers: [ChainUser], index: Int, error: @escaping (String?)->()) {
        let invite = ["chain": chainName, "sentBy": sender.username, "index": index] as [String : Any]
        for user in receivers {
            let firestoreRef = Firestore.firestore().collection("users").document(user.phoneNumber)
            firestoreRef.updateData([
                "invites": FieldValue.arrayUnion([invite])
            ]) { (err1) in
                       if let error1 = err1{
                           masterNav.showPopUp(_title: "Error sending invite", _message: error1.localizedDescription)
                           error(error1.localizedDescription)
                       }else{
                           error(nil)
                       }
            }
        }
    }
    
    func deleteChainFromFirestore(chain:PostChain, error: @escaping(String?)->()) {
        let functions = Functions.functions()
        let callData:[String:Any] = ["chain":chain.chainUUID, "user":masterAuth.currUser.phoneNumber]
        functions.httpsCallable("deleteChain").call(callData) { (result, err) in
            guard let message = (result?.data as! [String:Any])["message"] as? String else{ error("message error"); return }
            if message.contains(find: "success"){
                error(nil)
            }else{
                error(message)
            }
        }
        
    }
    
}
