//
//  ChainImage.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase

class ChainImage{
    
    var link:String
    var user:String
    var userProfile:String
    var userPhone:String
    var time:Date
    var uuid:String
    var image:UIImage?
    var loadState = LoadState.NOT_LOADED
    var delegate:ChainImageDelegate?
    var localIndex:Int = 0
    var widthImage:CGFloat = 0.0
    var heightImage:CGFloat = 0.0
    var isLiked:Bool = false
    var parentChain:PostChain?
    var lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))
    var responses = [ChainImage]()
    var numberOfImagesInPost = 1 //Might need a listener
    
    static var emptyPost:ChainImage{
        get{return ChainImage(link: "noLink", user: "noUser", userProfile: "noProfile", userPhone: "noPhone", image: UIImage(named: "fakeImg")!)}
    }
    
    //When created by user locally after image is uploaded
    init(link:String, user:String, userProfile:String, userPhone:String, image:UIImage){
        self.loadState = .NOT_LOADED
        self.image = image
        self.link = link
        self.user = user
        self.userProfile = userProfile
        self.userPhone = userPhone
        self.time = Date() //Convert to string
        self.uuid = UUID().uuidString
    }
    
    /// Local Init, the user will need to be very careful using this. Make sure you upload it to the chain
    /// - Parameter image: the image to be posted
    init(image:UIImage){
        self.loadState = .NOT_LOADED
        self.image = image
        self.link = ""
        self.user = masterAuth.currUser.phoneNumber
        self.time = Date()
        self.userPhone = masterAuth.currUser.phoneNumber
        self.userProfile = masterAuth.currUser.phoneNumber
        self.uuid = UUID().uuidString
    }
    
    //When pulled from firestore
    init?(dict:[String:Any], parentChain:PostChain){
        
        let _time = (dict["Time"] as? Timestamp)
        self.lastReadTimestamp = _time!
        let _user = dict["user"] as? String ?? ""
        let _uuid = (dict["uuid"] as? String)
        let _countPosts = (dict["numberOfImages"] as? Int)
        let _link = (dict["Link"] as? String)
        self.link = _link ?? ""
        self.time = (_time!.dateValue())
        self.user = _user
        self.uuid = _uuid ?? ""
        self.numberOfImagesInPost = _countPosts ?? 1
        self.userPhone = dict["userPhone"] as? String ?? ""
        self.userProfile = dict["userProfile"] as? String ?? ""
        self.widthImage = CGFloat(dict["width"] as? Double ?? 400.0)
        self.heightImage = CGFloat(dict["height"] as? Double ?? 400.0)
        self.loadState = .NOT_LOADED
        self.didUserLike { (didLike) in }
    }
    
    func toFunctionsDict()->[String:Any]{
        var retDict = self.toDict()
        retDict["Time"] = self.time.toISO()
        return retDict
    }
    
    func toDict()->[String:Any]{
        if widthImage == 0.0 || heightImage == 0.0{
            fatalError("No Width/heithgt")
        }
        let retDict:[String:Any] = ["Link": self.link,
                                    "Time": Timestamp(date: self.time),
                                    "user": self.user,
                                    "userProfile": self.userProfile,
                                    "userPhone": self.userPhone,
                                    "index": self.localIndex,
                                    "width": self.widthImage,
                                    "height": self.heightImage,
                                    "uuid": self.uuid,
                                    "numberOfImages": self.numberOfImagesInPost]
        
        return retDict
    }
    
    func toDict(height: CGFloat, width: CGFloat)->[String:Any]{
        self.widthImage = width
        self.heightImage = height
        let retDict:[String:Any] = ["Link": self.link,
                                    "Time": self.time.timeIntervalSince1970,
                                    "user": self.user,
                                    "userProfile": self.userProfile,
                                    "userPhone": self.userPhone,
                                    "index": self.localIndex,
                                    "width": self.widthImage,
                                    "height": self.heightImage,
                                    "uuid": self.uuid,
                                    "numberOfImages": self.numberOfImagesInPost]
        
        return retDict
    }
    
    func like(success: @escaping(Bool)->()){
        if parentChain == nil {print("No parent chain, cant load likes"); return}
        let ref = masterFire.db.collection("chains").document(self.parentChain!.chainUUID).collection("posts").document(self.uuid).collection("likes").document(masterAuth.currUser.phoneNumber)
        ref.setData(["user": masterAuth.currUser.phoneNumber]) { (err) in
            if err == nil{
                self.isLiked = true
                success(true)
            }else{
                success(false)
            }
        }
    }
    
    func didUserLike(yes: @escaping(Bool)->()){
        if parentChain == nil {print("No parent chain, cant load likes"); return}
        let ref = masterFire.db.collection("chains").document(self.parentChain!.chainUUID).collection("posts").document(self.uuid).collection("likes")
        ref.whereField("user", isEqualTo: masterAuth.currUser.phoneNumber).getDocuments { (snap, err) in
            guard let docs = snap?.documents else {yes(false); return}
            if docs.count >= 1{
                self.isLiked = true
                yes(true)
            }else{
                yes(false)
            }
        }
    }
    
    func load(){ //Switch to Kingfisher
        if (loadState == .LOADING) || (loadState == .LOADED){
            return
        }
        //firestore pull initialization
        self.loadState = .LOADING
        let url = URL(string: self.link)
        //imageView.kf.setImage(with: url)
        //print("Downloading: \(self.link)")
        //self.loadState = .LOADED
        self.delegate?.imageDidLoad(chainImage: self)
        //
        /*
        if let url =  URL(string: self.link){
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                //print("Downloaded: \(self.link)")
                //DispatchQueue.main.async() {
                self.image = UIImage(data: data)
                if self.image == nil{
                    print("Failed to download: \(self.link)")
                    return
                }
                self.loadState = .LOADED
                self.delegate?.imageDidLoad(chainImage: self)
                //}
            }
        }else{
            print("Failed URL conversion: \(self.link)")
        }
        */
    }
    
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func uploadImage(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
    }
    
    func getNextPost(completion: @escaping (ChainImage) -> ()) { //
        let responseRef = masterFire.db.collection("chains").document(self.parentChain?.chainUUID ?? "").collection("posts").document(self.uuid).collection("responses")
        print(self.lastReadTimestamp.dateValue())
        
        responseRef.whereField("Time", isGreaterThan: self.lastReadTimestamp).limit(to: 1).getDocuments(){ (querySnapshot, err) in
        if let err = err {print("Error getting documents: \(err)")} else {
                for document in querySnapshot!.documents {
                    self.responses.append(ChainImage(dict: document.data(), parentChain: self.parentChain!)!)
                    self.lastReadTimestamp = document.get("Time") as? Timestamp ?? self.lastReadTimestamp
                    completion(ChainImage(dict: document.data(), parentChain: self.parentChain!)!)
                }
            }
        }
    }
    
}


protocol ChainImageDelegate {
    func imageDidLoad(chainImage: ChainImage)
}
