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
    var allChains:[String: PostChain] = [:]
    
    

    //If error comes back as nil, then nothing went wrong
    func uploadChain(chain:PostChain, error: @escaping (String?)->()) {
        //Add sub-collections
        let firestoreRef = Firestore.firestore().collection("chains").document(chain.chainID)
        //  firestoreRef.collection("posts")
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
        print(chainID)
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
    /*
    func appendChain(chainID: String, image:UIImage, completion: @escaping (String?, ChainImage?)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("chains").document(chainID)
        let data = image.jpegData(compressionQuality: 1.0)!
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("Fitwork Images").child(imageName)
        let metaDataForImage = StorageMetadata() //
        metaDataForImage.contentType = "image/jpeg" //
        imageReference.putData(data, metadata: metaDataForImage) { (meta, err1) in //metadata: nil to metaDataForImage
            if err1 != nil {completion("Error uploading to cloud: \(err1!.localizedDescription)", nil); return}
            imageReference.downloadURL(completion: { (url, err2) in
                if err2 != nil {completion("Error getting URL", nil); return}
                if url == nil {completion("Error loading URL", nil); return}
                urlString = url!.absoluteString //Hold URL
                print(urlString)
                let uploadImage = ChainImage(link: urlString, user: "mbrutkow", image: image)
                firestoreRef.updateData([
                    "posts": FieldValue.arrayUnion([uploadImage.toDict()]), "count": FieldValue.increment(Int64(1))
                ]) { (err1) in
                    if let error1 = err1{
                        masterNav.showPopUp(_title: "Error Uploading Image to Chain", _message: error1.localizedDescription)
                        completion(error1.localizedDescription, nil)
                    } else{
                        completion(nil, uploadImage)
                    }
                   }
                })
            }
    }
    */
    func removeFromChain(chainID: String, post:[String:Any], completion: @escaping (String?)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("chains").document(chainID)
        firestoreRef.updateData([
            "posts": FieldValue.arrayRemove([post]), "count": FieldValue.increment(Int64(1))
        ])
        
    }
    
    
    func addFriend(friend: [String:Any], error: @escaping (String?)->()) {
        //Add other user to current user's friend list
        let currentUserBasicInfo = ["phone": currentUser.phoneNumber, "profile": currentUser.profile, "username": currentUser.username] as [String:Any]
        var firestoreRef = Firestore.firestore().collection("users").document(currentUser.phoneNumber)
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
            "friends": FieldValue.arrayUnion([currentUser])
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
        let currentUserBasicInfo = ["phone": currentUser.phoneNumber, "profile": currentUser.profile, "username": currentUser.username] as [String:Any]
        var firestoreRef = Firestore.firestore().collection("users").document(currentUser.phoneNumber)
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
            "friends": FieldValue.arrayRemove([currentUser])
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
    
    
    func inviteFriend(chainID: String, sendUser: String, index: Int, error: @escaping (String?)->()) {
        //In Invitation object for now
        
        
    }
    func getCurrentUsersData(phone: String, error: @escaping (String?)->()) {
        //When user signs in, gather their data
        db.collection("users").whereField("phone", isEqualTo: phone).getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                //currentUser.friends = document.get("friends") as? [[String:Any]] ?? [[:]]
                let blocked = document.get("blocked") as? [String] ?? [""]
                let invites = document.get("invites") as? [[String:Any]] ?? [[:]]
                let phone = document.get("phone") as? String ?? ""
                let profilePhoto = document.get("profilePhoto") as? String ?? ""
                let topPhotos = document.get("topPhotos") as? [[String:Any]] ?? [[:]]
                currentUser.bio = document.get("bio") as? String ?? ""
                currentUser.name = document.get("name") as? String ?? ""
                currentUser.username = document.get("username") as? String ?? ""
                currentUser.blocked = blocked
                currentUser.invites = invites
                currentUser.phoneNumber = phone
                currentUser.profile = profilePhoto
                currentUser.topPosts = topPhotos
                //Need to save chains, friends, and blocked as well
                
            }
            currentUser.getFriends()
            
            //let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
            let mainVC = ExploreViewController()
            //mainVC.mainChain = PostChain(chainID: "firstChain", load: true)
            //mainVC.mainChain.chainUID = "firstChain"
            masterNav.pushViewController(mainVC, animated: true) //Push MainChain
            }
        }
    }
    
    func updateFriendsFeed(chain: PostChain, error: @escaping (String?)->()) {
        //userID = phone number
        for user in currentUser.friends {
            let postRef = db.collection("userFeeds").document(user.phoneNumber).collection("posts")
            postRef.document(chain.chainID).setData(chain.toDict()) { (error) in if let err = error {print(err.localizedDescription)} else {
                    //Consider only uploading to top friends
                }
            }
        }
    }
    
    func loadNextFewPhotos() {
        
    }
    
    func reportImage(chainID: String, image: ChainImage, error: @escaping (String?)->()) {
        //Create and upload doc
        var ref: DocumentReference? = nil
        ref = db.collection("reportedPosts").addDocument(data: image.toDict()) { err in
            if let err = err {
                print("Error Reporting: \(err)")
            } else {
                print("Successfully Reported: \(ref!.documentID)")
            }
        }
        
    }
    
    func shareChain(chainID: String, sender: ChainUser, receivers: [ChainUser], index: Int, error: @escaping (String?)->()) {
        let invite = ["chain": chainID, "sentBy": sender.username, "index": index] as [String : Any]
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
}
