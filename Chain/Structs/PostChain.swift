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
    var chainID:String
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
    var chainUID:String = ""
    
    init(_chainID:String, _birthDate:Date, _deathDate:Date, _tags:[String]?){
        self.chainID = _chainID
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
    }
    
    init(chainID:String, load:Bool = true){
        self.chainID = chainID
        self.birthDate = Date()
        self.deathDate = Date()
        self.likes = 0
        self.count = 0
        self.tags = []
        self.contributors = []
        self.coordinate = CLLocationCoordinate2D()
        self.posts = []
        self.loaded = .NOT_LOADED
        if load{
            self.load { (error) in
                if error != nil{ print("Failed loading chain \(self.chainID): \(error!)")}
            }
        }
    }
    
    init(dict:[String:Any]){
        self.chainID = dict["chainID"] as! String   //want this to fail if it doesnt exist
        self.chainUID = dict["chainUID"] as! String 
        self.birthDate = Date(chainString: dict["birthDate"] as! String)
        self.deathDate = Date(chainString: dict["deathDate"] as! String)
        self.likes = dict["likes"] as! Int
        self.count = dict["count"] as! Int
        self.tags = dict["tags"] as? [String] ?? []
        self.contributors = dict["contributors"] as? [String] ?? []
        let postsData = dict["posts"] as? [[String:Any]] ?? []
        for postData in postsData{
            if let img = ChainImage(dict: postData){
                self.posts.append(img)
            }
        }
        self.loaded = .LOADED
        let latLong = dict["l"] as? [Double] ?? [0.0, 0.0]
        self.coordinate = CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
        self.firstImageLink = dict["firstImageLink"] as? String
        if (self.firstImageLink == nil) && (self.posts.count > 0){
            self.firstImageLink = self.posts[0].link
        }
    }
    
    func toDict(withPosts:Bool = true)->[String:Any]{
        
        //let geoData = GeoFirestore.getFirestoreData(for: self.coordinate)!
        
        var retDict:[String:Any] = ["chainID" : self.chainID,
                                    "birthDate" : self.birthDate.toChainString(),
                                    "deathDate" : self.deathDate.toChainString(),
                                    "likes" : self.likes,
                                    "count": self.count,
                                    "tags" : self.tags,
                                    "contributors" : self.contributors]
        if self.firstImageLink != nil{
            retDict["firstImageLink"] = self.firstImageLink!
        }
        /*
        "l" : geoData["l"] as! [Double],
        "g" : geoData["g"] as! String] */
        return retDict
    }
    
    
    
    func postsData()->[[String:Any]]{
        var postsData:[[String:Any]] = []
        var index = 0
        for post in self.posts{
            postsData.append(post.toDict())
            self.posts[index].localIndex = index
            index += 1
        }
        return postsData
    }
    
    func load(error: @escaping ((String?)->())){
        //self.chainUID = "firstChain" 
        masterFire.loadChain(chainID: self.chainUID) { (chain) in
            if chain != nil{
                self.birthDate = chain!.birthDate
                self.deathDate = chain!.deathDate
                self.likes = chain!.likes
                self.count = chain!.count
                self.tags = chain!.tags
                self.contributors = chain!.contributors
                self.coordinate = chain!.coordinate
                self.posts = chain!.posts
                self.firstImageLink = chain!.firstImageLink
                self.loaded = .LOADED
                self.chainUID = chain!.chainUID
                for delegate in self.delegates.values{
                    delegate.chainDidLoad(chain: self)
                }
                error(nil)
            }else{
                error("Error loading")
            }
        }
    }
    
    /// Will post the chain from the object
    /// - Parameter err: if this returns nil, the post was successful
    func post(image: UIImage, error: @escaping (String?)->()){
        //if self.posts.count != 1{error("Error: You need 1 post in self.posts to upload the chain"); return}
        let docRef = Firestore.firestore().collection("chains").document().documentID
        print(docRef)
        self.chainUID = docRef
        masterFire.db.collection("chains").document(docRef).setData(self.toDict(withPosts: false)) { (err1) in
            if err1 != nil{error(err1!.localizedDescription); return} else {
                //DocumentReference
                self.append(image: image) { (err2, postedImage) in
                    if err2 != nil{error(err2); return}
                }
                
            }
        }
    }
    
    func append(image:UIImage, completion: @escaping (String?, ChainImage?)->()) {
        var urlString = "" //Will hold URL string to create Chain Image
        let firestoreRef = Firestore.firestore().collection("chains").document(self.chainUID)
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
                let dict = uploadImage.toDict()
                //Add to sub-collection
                let postRef = Firestore.firestore().collection("chains").document(self.chainUID).collection("posts")
                postRef.addDocument(data: dict) { (error) in
                    if let err = error {
                        print("Error when adding doc: \(err)")
                        print("Localized Desc.: \(err.localizedDescription)")
                    } else {
                        print("Success appending image")
                        //self.posts.append(uploadImage)
                        masterNav.popViewController(animated: false)
                        let chainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
                        chainVC.mainChain = self
                        masterNav.pushViewController(chainVC, animated: true)
                        /* masterFire.updateFriendsFeed(chain: self) { (error) in
                            
                        } */
                    }
                }
                
                })
            }
    }
    
    private var listener: ListenerRegistration?
    private var hasLoadedInitial = false
    func listenForChanges(ignoreFirst:Bool = true){
        let chainRef = Firestore.firestore().collection("chains").document(self.chainID)
        listener = chainRef.addSnapshotListener { (snap, err) in
            if snap == nil{ return}
            if err != nil{print("error in snaplistener"); return}
            if ignoreFirst && !self.hasLoadedInitial{ self.hasLoadedInitial = true; return}
            
            let data = snap!.data()!
            let newChain = PostChain(dict: data)
            
            var newPost:ChainImage?
            var postDict:[String:ChainImage] = [:]
            for post in self.posts{
                postDict[post.link] = post
            }
            for post in newChain.posts{
                if postDict[post.link] == nil{
                    //Theres a new post!
                    newPost = post
                    postDict[post.link] = post
                }
            }
            
            let sortedPosts = postDict.sorted { $0.value.localIndex < $1.value.localIndex }
            var finalPosts:[ChainImage] = []
            var postCount = 0
            for post in sortedPosts{
                let tempPost = post.value
                tempPost.localIndex = postCount
                finalPosts.append(tempPost)
                if newPost != nil{
                    if tempPost.link == newPost!.link{
                        newPost!.localIndex = postCount
                    }
                }
                postCount += 1
            }
            self.posts = finalPosts
            if newPost != nil{
                for delegate in self.delegates.values{
                    delegate.chainGotNewPost(post: newPost!)
                }
            }
            self.hasLoadedInitial = true
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
}

protocol PostChainDelegate {
    func chainGotNewPost(post: ChainImage)
    func chainDidLoad(chain: PostChain)
}
