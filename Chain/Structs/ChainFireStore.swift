//
//  File.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import CoreLocation
import Geofirestore
import Firebase
import FirebaseFirestore

class ChainFireStore {
    //
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    var allChains:[String: PostChain] = [:]
    
    

    //If error comes back as nil, then nothing went wrong
    func uploadChain(chain:PostChain, error: @escaping (String?)->()) {
        let firestoreRef = Firestore.firestore().collection("chains").document(chain.chainID)                                    
        firestoreRef.setData(chain.toDict()) { (err1) in
            if let error1 = err1{
                masterNav.showPopUp(_title: "Error Uploading Chain", _message: error1.localizedDescription)
                error(error1.localizedDescription)
            }else{
                error(nil)
            }
        }
    }
    
    //Will be deprecated later, just for use during testing
    func loadChain(chainID:String, chain: @escaping (PostChain?)->()){
        let ref = Firestore.firestore().collection("chains").document(chainID)
        ref.getDocument { (snap, err) in
            if err == nil{
                let snapData = snap!.data()!
                chain(PostChain(dict: snapData))
            }else{
                chain(nil)
            }
        }
    }
    
    //Added
    func appendChain(chain:PostChain, image:ChainImage, error: @escaping (String?)->()) {
        let firestoreRef = Firestore.firestore().collection("chains").document(chain.chainID)
        
        
        
        firestoreRef.updateData([
            "posts": FieldValue.arrayUnion([image.toDict()]), "likes": chain.likes += 1 //Need to increment correctly
        ]) { (err1) in
            if let error1 = err1{
                masterNav.showPopUp(_title: "Error Uploading Image to Chain", _message: error1.localizedDescription)
                error(error1.localizedDescription)
            }else{
                error(nil)
            }
        }
        
        //let ref = FirestoreReferenceManager
    }
    //TODO: Make better chain function
    //Will user for good, could return a lot of IDs, we can paginate this also, which we will need to do
//    func loadChainIDs(){
//
//    }
    func addFriend(currentUser: String, friend: String, error: @escaping (String?)->()) {
        //Add other user to current user's friend list
        var firestoreRef = Firestore.firestore().collection("users").document(currentUser)
        firestoreRef.updateData([
            "friends": FieldValue.arrayUnion([friend])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error adding friend to friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
        //Add current user to other user's friends list
        firestoreRef = Firestore.firestore().collection("users").document(friend)
        firestoreRef.updateData([
            "friends": FieldValue.arrayUnion([currentUser])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error adding friend to friends list", _message: error1.localizedDescription)
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
    
    func inviteFriend(chainID: String, sendUser: String, index: Int, error: @escaping (String?)->()) {
        
        
    }
    
    //Function to get basic of chain (Title, tags, description, length, likes, count, etc.)
    
}
