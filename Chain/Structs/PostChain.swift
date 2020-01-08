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
    
    init(_chainID:String, _birthDate:Date, _deathDate:Date, _tags:[String]?){
        self.chainID = _chainID
        self.birthDate = _birthDate
        self.deathDate = _deathDate
        self.likes = 0
        self.count = 1
        self.tags = _tags ?? []
        self.contributors = [masterAuth.currUser.username]
        self.coordinate = masterLocator.getCurrentLocation()!.coordinate
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
                print(error)
            }
        }
    }
    
    init(dict:[String:Any]){
        self.chainID = dict["chainID"] as! String   //want this to fail if it doesnt exist
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
        let latLong = dict["l"] as! [Double]
        self.coordinate = CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
        self.firstImageLink = dict["firstImageLink"] as? String
        if (self.firstImageLink == nil) && (self.posts.count > 0){
            self.firstImageLink = self.posts[0].link
        }
    }
    
    func toDict()->[String:Any]{
        
        //let geoData = GeoFirestore.getFirestoreData(for: self.coordinate)!
        
        var retDict:[String:Any] = ["chainID" : self.chainID,
                                    "birthDate" : self.birthDate.toChainString(),
                                    "deathDate" : self.deathDate.toChainString(),
                                    "likes" : self.likes,
                                    "count": self.count,
                                    "tags" : self.tags,
                                    "contributors" : self.contributors,
                                    "posts": self.postsData()]
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
        masterFire.loadChain(chainID: self.chainID) { (chain) in
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
    func post(error: @escaping (String?)->()){
        if self.posts.count != 1{error("Error: You need 1 post in self.posts to upload the chain"); return}
        
        masterFire.db.collection("chains").document(self.chainID).setData(self.toDict(), merge: true) { (err1) in
            if err1 != nil{error(err1!.localizedDescription); return}
            
            masterFire.appendChain(chainID: self.chainID, image: self.posts[0].image!) { (err2, postedImage) in
                if err2 != nil{error(err2); return}
                
                self.posts[0] = postedImage!    //This will now have more data than before
                error(nil)
            }
        }
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
    func chainDidLoad(chain: PostChain)
}
