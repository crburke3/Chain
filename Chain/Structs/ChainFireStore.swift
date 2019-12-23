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
    //Added "index" so once chain is loaded it starts in the correct spot
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
    func appendChain(chainID: String, image:UIImage, error: @escaping (String?)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("chains").document(chainID)
        let data = image.jpegData(compressionQuality: 1.0)!
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("Fitwork Images").child(imageName)
        let metaDataForImage = StorageMetadata() //
        metaDataForImage.contentType = "image/jpeg" //
        imageReference.putData(data, metadata: metaDataForImage) { (meta, err) in //metadata: nil to metaDataForImage
            if let err = err {
                print("Error sending photo to cloud")
                return
            }
            imageReference.downloadURL(completion: { (url, err) in
                if let err = err {
                    print("Error loading URL")
                    return
                }
                guard let url = url else{
                    print("Error loading URL")
                    return
                }
                urlString = url.absoluteString //Hold URL
                print(urlString)
                let uploadImage = ChainImage(link: urlString, user: "mbrutkow", image: image)
                firestoreRef.updateData([
                    "posts": FieldValue.arrayUnion([uploadImage.toDict()])
                ]) { (err1) in
                    if let error1 = err1{
                        masterNav.showPopUp(_title: "Error Uploading Image to Chain", _message: error1.localizedDescription)
                        error(error1.localizedDescription)
                    } else{
                        error(nil)
                    }
                   }
                })
            }
    }
    
    //func removeFromChain()
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
    func removeFriend(currentUser: String, friend: String, error: @escaping (String?)->()) {
        //Add other user to current user's friend list
        var firestoreRef = Firestore.firestore().collection("users").document(currentUser)
        firestoreRef.updateData([
            "friends": FieldValue.arrayRemove([friend])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error removing friend from friends list", _message: error1.localizedDescription)
                       error(error1.localizedDescription)
                   }else{
                       error(nil)
                   }
        }
        //Add current user to other user's friends list
        firestoreRef = Firestore.firestore().collection("users").document(friend)
        firestoreRef.updateData([
            "friends": FieldValue.arrayRemove([currentUser])
        ]) { (err1) in
                   if let error1 = err1{
                       masterNav.showPopUp(_title: "Error removing friend from friends list", _message: error1.localizedDescription)
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
        //In Invitation object for now
        
        
    }
    func getCurrentUsersData(currentUser: String, error: @escaping (String?)->()) {
        //When user signs in, gather their data
        
    }
    func updateFriendsFeed(chainID: String, error: @escaping (String?)->()) {
        //Place created chain or involved-in chain onto every friend's feed
        
    }
    func loadNextFewPhotos() {
        
    }
    //Function to get basic of chain (Title, tags, description, length, likes, count, etc.)
    
}
