//
//  Chain.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore
import FirebaseStorage
//import Geofirestore


class PostChain{
    var chainName:String
    var birthDate:Date
    var deathDate:Date
    var likes:Int
    var count:Int
    var tags:[String]
    var contributors:[String]
    var coordinate:CLLocationCoordinate2D
    var posts:[ChainImage] = []
    var loaded: LoadState
    var delegates: [String:PostChainDelegate] = [:]
    var firstImageLink:String?
    var chainUUID:String = ""
    var lastReadBirthDate =  Date(timeIntervalSinceReferenceDate: -123456789.0) //Keeps track of last read cell, acts as a cursor for pagination
    var testTime:Timestamp
    
    init(_chainName:String, _birthDate:Date, _deathDate:Date, _tags:[String]?){
        self.chainName = _chainName
        self.birthDate = _birthDate
        self.deathDate = _deathDate
        self.likes = 0
        self.count = 1
        self.tags = _tags ?? []
        self.contributors = ["cburke"]
        self.coordinate = CLLocation().coordinate //masterLocator.getCurrentLocation()!.coordinate
        self.loaded = .LOADED
        if posts.count > 0{
            firstImageLink = posts[0].link
        }
        self.testTime = Timestamp(date: self.birthDate)
    }
    
    init(chainName:String, load:Bool = true){
        self.chainName = chainName
        self.chainUUID = chainName
        self.birthDate = Date()
        self.deathDate = Date()
        self.likes = 0
        self.count = 0
        self.tags = []
        self.contributors = []
        self.coordinate = CLLocationCoordinate2D()
        self.posts = []
        self.loaded = .NOT_LOADED
        self.testTime = Timestamp(date: self.birthDate)
    }
    
    init?(dict:[String:Any]){
        self.chainName = dict["chainName"] as! String   //want this to fail if it doesnt exist
        self.chainUUID = dict["chainUUID"] as! String 
        self.birthDate = (dict["birthDate"] as! Timestamp).dateValue()
        self.deathDate = (dict["deathDate"] as! Timestamp).dateValue()
        self.likes = dict["likes"] as! Int
        self.count = dict["count"] as! Int
        self.tags = dict["tags"] as? [String] ?? []
        self.contributors = dict["contributors"] as? [String] ?? []
        self.testTime = Timestamp(date: self.birthDate)
        //Posts will be appended to chain object from sub-collection seperately
        //let postsData = dict["posts"] as? [[String:Any]] ?? []
        /* for postData in postsData{
            if let img = ChainImage(dict: postData){
                self.posts.append(img)
            }
        } */
        self.loaded = .LOADED
        let latLong = dict["l"] as? [Double] ?? [0.0, 0.0]
        self.coordinate = CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
        self.firstImageLink = dict["firstImageLink"] as? String
        if (self.firstImageLink == nil) && (self.posts.count > 0){
            self.firstImageLink = self.posts[0].link
        }
    }
    
    func uploadChain(chain:PostChain, image:UIImage, error: @escaping (String?)->()) {
        //Upload first image
        //Get url
        //Edit chain object
        //Upload to FS
        //Append image
        let db = Firestore.firestore()
        let newChainRef = db.collection("chains").document()
        let firestoreRef = Firestore.firestore().collection("chains").document(newChainRef.documentID)
        chain.chainUUID = newChainRef.documentID
        firestoreRef.setData(chain.toDict()) { (err1) in
            if let error1 = err1{
                masterNav.showPopUp(_title: "Error Uploading Chain", _message: error1.localizedDescription)
                error(error1.localizedDescription)
            }else{
                self.append(image: image, source: "general") { (err, postedImage) in
                    if err != nil { print(err) } else {
                        self.firstImageLink = postedImage?.link
                        db.collection("chains").document(self.chainUUID).updateData(["firstImageLink" : self.firstImageLink])
                    }
                }
                error(nil)
            }
        }
    }

    
    func toDict(withPosts:Bool = true)->[String:Any]{
        let retDict:[String:Any] = ["chainName" : self.chainName,
                                    "chainUUID" : self.chainUUID,
                                    "birthDate" : self.birthDate,
                                    "deathDate" : self.deathDate,
                                    "likes" : self.likes,
                                    "count": self.count,
                                    "tags" : self.tags,
                                    "contributors" : self.contributors,
                                    "firstImageLink" : self.firstImageLink]
        return retDict
    }
    
    
    
    func postsData()->[[String:Any]]{
        var postsData:[[String:Any]] = []
        var index = 0
        for post in self.posts{
            //postsData.append(post.toDict())
            self.posts[index].localIndex = index
            index += 1
        }
        return postsData
    }
    
    func loadPost(postSource: String = "chains", post: @escaping (ChainImage)->()){
        //chainSource -> global or general
        var postRef = masterFire.db.collection("chains").document(self.chainUUID).collection("posts")
        switch postSource {
            case "global":
                postRef = masterFire.db.collection("globalFeed").document(self.chainUUID).collection("posts")
                break
            case "general": //For user feed and general
                postRef = masterFire.db.collection("chains").document(self.chainUUID).collection("posts")
                break
            default: break
        }
        //Get next document/post
        
        postRef.whereField("Time", isGreaterThan: self.testTime).limit(to: 1).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print(self.testTime.dateValue())
                        self.testTime = (document.get("Time") as? Timestamp)!
                        var dict = document.data() as [String : Any]
                        dict["uuid"] = document.documentID
                        if let _post = ChainImage(dict: dict, parentChain: self){
                            post(_post)
                        }
                    }
                }
            post(ChainImage(link: "noLink", user: "noUser", userProfile: "noProfile", userPhone: "noPhone", image: UIImage(named: "fakeImg")!)) //Empty post, needs error image
        }
        
    }
    
    func append(image:UIImage, source:String, completion: @escaping (String?, ChainImage?)->()) {
        var urlString = ""
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
                let uploadImage = ChainImage(link: urlString, user: currentUser.username, userProfile: currentUser.profile, userPhone: currentUser.phoneNumber, image: image)
                let dict = uploadImage.toDict(height: image.size.height, width: image.size.width)
                var postRef: CollectionReference
                if source == "general" {
                    postRef = Firestore.firestore().collection("chains").document(self.chainUUID).collection("posts")
                } else {
                    postRef = Firestore.firestore().collection("globalFeed").document(self.chainUUID).collection("posts")
                }
                postRef.addDocument(data: dict) { (error) in
                    if let err = error {
                        print("Error when adding doc: \(err)")
                        print("Localized Desc.: \(err.localizedDescription)")
                    } else {
                        print("Success appending image")
                        self.localAppend(post: uploadImage)
                        if self.posts.count == 1 {
                            self.firstImageLink = uploadImage.link
                        }
                        //Loading indicator
                        self.lastReadBirthDate = uploadImage.time
                        self.testTime = Timestamp(date: uploadImage.time)
                        masterNav.popViewController(animated: true)
                        masterFire.updateFriendsFeed(chain: self) { (error) in
                            //
                        }
                        completion(nil, uploadImage)
                    }
                }
            })
        }
    }
    
    private var listener: ListenerRegistration?
    private var hasLoadedInitial = false
    
    func listenForChanges(ignoreFirst:Bool = true){ //Needs to be updated
        let chainRef = Firestore.firestore().collection("chains").document(self.chainName)
        listener = chainRef.addSnapshotListener { (snap, err) in
            //Use listener to update chains as people post
        }
    }
    
    func stopListeningForChanges(){
        listener?.remove()
    }
    
    func addDelegate(delegateID:String, delegate: PostChainDelegate){
        self.delegates[delegateID] = delegate
    }
    
    func removeDelegate(delegateID:String){
        self.delegates.removeValue(forKey: delegateID)
    }
    
    func removeAllDelegates(){
        self.delegates = [:]
    }
    
    func setHighestIndex(birthDate: Date) {
        if birthDate > self.lastReadBirthDate {
            self.lastReadBirthDate = birthDate
        }
    }
    
    func localAppend(post:ChainImage){
        post.parentChain = self
        self.posts.append(post)
    }
}

protocol PostChainDelegate {
    func chainGotNewPost(post: ChainImage)
    func chainDidLoad(chain: PostChain)
}
