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
import FirebaseFunctions
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
    var lastPostLoaded:QueryDocumentSnapshot?
    var testTime:Timestamp
    var isDead:Bool = false
    var creator:ChainUser?
    
    init(_chainName:String, _birthDate:Date, _deathDate:Date, _tags:[String]?){
        self.chainName = _chainName
        self.birthDate = _birthDate
        self.deathDate = _deathDate
        self.likes = 0
        self.count = 1
        self.tags = _tags ?? []
        self.contributors = [masterAuth.currUser.phoneNumber]
        self.coordinate = CLLocation().coordinate //masterLocator.getCurrentLocation()!.coordinate
        self.loaded = .LOADED
        self.chainUUID = UUID().uuidString
        if posts.count > 0{
            firstImageLink = posts[0].link
        }
        self.testTime = Timestamp(date: self.birthDate)
        self.creator = masterAuth.currUser
    }
    
    init(chainUUID:String){
        self.chainName = "not loaded"
        self.chainUUID = chainUUID
        self.birthDate = Date()
        self.deathDate = Date()
        self.likes = 0
        self.count = 0
        self.tags = []
        self.contributors = ["+17048062009"]
        self.coordinate = CLLocationCoordinate2D()
        self.posts = []
        self.loaded = .NOT_LOADED
        self.testTime = Timestamp(date: self.birthDate)
    }
    
    init?(dict:[String:Any]){
        guard let _chainName = dict["chainName"] as? String,
            let _chainUUID = dict["chainUUID"] as? String,
            let _birthDate = dict["birthDate"] as? Timestamp,
            let _deathDate = dict["deathDate"] as? Timestamp
        else{ return nil }
        
        if let _creatorDict = dict["creator"] as? [String:Any]{
            self.creator = ChainUser(dict: _creatorDict)
        }
        self.chainName = _chainName
        self.chainUUID = _chainUUID
        self.birthDate = _birthDate.dateValue()
        self.deathDate = _deathDate.dateValue()
        self.likes = dict["likes"] as? Int ?? 0
        self.count = dict["count"] as? Int ?? 1
        self.tags = dict["tags"] as? [String] ?? []
        self.contributors = dict["contributors"] as? [String] ?? ["+17048062009"]
        self.testTime = Timestamp(date: self.birthDate)        //Posts will be appended to chain object from sub-collection seperately
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
    
    func uploadChain(error: @escaping (String?)->()) {
        if self.posts.count <= 0{ error("posts are empty"); return }
        let image = posts[0].image!
        let functions = Functions.functions()
        let data = image.jpegData(compressionQuality: 1.0)!
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child("Fitwork Images").child(imageName)
        let metaDataForImage = StorageMetadata() //
        metaDataForImage.contentType = "image/jpeg" //
        imageReference.putData(data, metadata: metaDataForImage) { (meta, err1) in //metadata: nil to metaDataForImage
            if err1 != nil {error("Error uploading to cloud: \(err1!.localizedDescription)"); return}
            imageReference.downloadURL(completion: { (url, err2) in
                if err2 != nil {error("Error getting URL"); return}
                if url == nil {error("Error loading URL"); return}
                let urlString = url!.absoluteString //Hold URL
                self.firstImageLink = urlString
                self.posts[0].link = urlString
                let callData:[String:Any] = ["chainData" : self.toFunctionsDict(),
                                             "firstPost" : self.posts[0].toFunctionsDict(),
                                             "userID"    : masterAuth.currUser!.phoneNumber]
                
                functions.httpsCallable("helloWorld").call(callData) { (result, err2) in
                    if err2 != nil{error(err2?.localizedDescription); return}
                    if result == nil{error("No Result"); return}
                    if let data = result!.data as? [String:Any]{
                        if let message = data["message"] as? String{
                            if message.contains(find: "success"){
                                error(nil)
                            }else{
                                error(message)
                            }
                        }else{
                            error("Messaging Error")
                        }
                    }else{
                        error("Data Error")
                    }
                }
            })
        }
    }
    
    func toFunctionsDict()->[String:Any]{
        var retDict = self.toDict()
        retDict["birthDate"] = self.birthDate.toISO()
        retDict["deathDate"] = self.deathDate.toISO()
        return retDict
    }
    
    func toDict()->[String:Any]{
        var retDict:[String:Any] = ["chainName" : self.chainName,
                                    "chainUUID" : self.chainUUID,
                                    "birthDate" : Timestamp(date: birthDate),
                                    "deathDate" : Timestamp(date: deathDate),
                                    "likes" : self.likes,
                                    "count": self.count,
                                    "tags" : self.tags,
                                    "contributors" : self.contributors]
        if creator != nil{
            retDict["creator"] = self.creator!.toDict()
        }
        if firstImageLink != nil{
           retDict["firstImageLink"] = self.firstImageLink!
        }
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
    
    func load(err: @escaping(String?)->()){
        let ref = masterFire.db.collection("chains").document(self.chainUUID)
        ref.getDocument { (snap, err1) in
            guard let dict = snap?.data() else{ err("bad dict"); return }
            guard let _chainName = dict["chainName"] as? String,
                let _chainUUID = dict["chainUUID"] as? String,
                let _birthDate = dict["birthDate"] as? Timestamp,
                let _deathDate = dict["deathDate"] as? Timestamp
                else{ err("bad data"); return }
            
            self.chainName = _chainName
            self.chainUUID = _chainUUID
            self.birthDate = _birthDate.dateValue()
            self.deathDate = _deathDate.dateValue()
            self.likes = dict["likes"] as? Int ?? 0
            self.count = dict["count"] as? Int ?? 1
            self.tags = dict["tags"] as? [String] ?? []
            self.contributors = dict["contributors"] as? [String] ?? []
            self.testTime = Timestamp(date: self.birthDate)
            self.loaded = .LOADED
            let latLong = dict["l"] as? [Double] ?? [0.0, 0.0]
            self.coordinate = CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
            self.firstImageLink = dict["firstImageLink"] as? String
            if (self.firstImageLink == nil) && (self.posts.count > 0){
                self.firstImageLink = self.posts[0].link
            }
            for delegate in self.delegates.values{
                delegate.chainDidLoad(chain: self)
            }
        }
    }
    
    func loadPost(post: @escaping (ChainImage)->()){
        //chainSource -> global or general
        let postRef = masterFire.db.collection("chains").document(self.chainUUID).collection("posts")
        
        postRef.whereField("Time", isGreaterThan: self.testTime).limit(to: 1).getDocuments() { (querySnapshot, err) in
        //postRef.limit(to: 1).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                post(ChainImage(link: "noLink", user: "noUser", userProfile: "noProfile", userPhone: "noPhone", image: UIImage(named: "fakeImg")!)) //Empty post, needs error image
            } else {
                for document in querySnapshot!.documents {
                    //print(self.testTime.dateValue())
                    self.testTime = (document.get("Time") as? Timestamp)!
                    var dict = document.data() as [String : Any]
                    dict["uuid"] = document.documentID
                    if let _post = ChainImage(dict: dict, parentChain: self){
                        post(_post)
                    }
                }
            }
        }
    }
    
    private var isLoadingPosts = false
    func loadPosts(count:Int = 10, posts: @escaping ([ChainImage])->()){
        if isLoadingPosts{posts([]); return}
        isLoadingPosts = true
        let postRef = masterFire.db.collection("chains").document(self.chainUUID).collection("posts")
        var query = postRef.order(by: "Time").limit(to: count)
        if lastPostLoaded != nil{
            query = postRef.order(by: "Time").start(afterDocument: self.lastPostLoaded!).limit(to: count)
        }
        query.getDocuments { (querySnapshot, err) in
            self.isLoadingPosts = false
            if let err = err {
                print("Error getting documents: \(err)")
                let retPosts = [ChainImage.emptyPost] //Empty post, needs error image
                posts(retPosts)
            } else {
                var retPosts:[ChainImage] = []
                for document in querySnapshot!.documents {
                    var dict = document.data() as [String : Any]
                    dict["uuid"] = document.documentID
                    if let _post = ChainImage(dict: dict, parentChain: self){
                        if self.localAppend(post: _post){
                            retPosts.append(_post)
                        }
                    }
                }
                if let lastPost = querySnapshot!.documents.last{
                    self.lastPostLoaded = lastPost
                }
                posts(retPosts)
            }
        }
    }
    
    func append(image:UIImage, completion: @escaping (String?, ChainImage?)->()) {
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
                let uploadImage = ChainImage(link: urlString, user: masterAuth.currUser.username, userProfile: masterAuth.currUser.profile, userPhone: masterAuth.currUser.phoneNumber, image: image)
                let dict = uploadImage.toDict(height: image.size.height, width: image.size.width)
                var postRef: CollectionReference
                postRef = Firestore.firestore().collection("chains").document(self.chainUUID).collection("posts")
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
    
    func localAppend(post:ChainImage)->Bool{
        post.parentChain = self
        for locpost in self.posts{
            if post.uuid == locpost.uuid{
                return false
            }
        }
        self.posts.append(post)
        return true
    }
    
    var viewController:ChainViewController{
        get{
            if let existingVC = masterNav.findViewController(with: "ChainViewController") as? ChainViewController{
                existingVC.mainChain = self
                return existingVC
            }else{
                let newVC = ChainViewController.initFrom(chain: self)
                return newVC
            }
        }
    }
}

protocol PostChainDelegate {
    func chainGotNewPost(post: ChainImage)
    func chainDidLoad(chain: PostChain)
    func chainDidDie(chain: PostChain)
}
