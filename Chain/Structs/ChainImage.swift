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
    var image:UIImage?
    var loadState = LoadState.NOT_LOADED
    var delegate:ChainImageDelegate?
    var localIndex:Int = 0
    var widthImage:CGFloat = 0.0
    var heightImage:CGFloat = 0.0
    
    //When created by user locally after image is uploaded
    init(link:String, user:String, userProfile:String, userPhone:String, image:UIImage){
        self.loadState = .NOT_LOADED
        self.image = image
        self.link = link
        self.user = user
        self.userProfile = userProfile
        self.userPhone = userPhone
        self.time = Date() //Convert to string
    }
    
    /// Local Init, the user will need to be very careful using this. Make sure you upload it to the chain
    /// - Parameter image: the image to be posted
    init(image:UIImage){
        self.loadState = .NOT_LOADED
        self.image = image
        self.link = ""
        self.user = ""
        self.time = Date()
        self.userPhone = ""
        self.userProfile = ""
    }
    
    //When pulled from firestore
    init?(dict:[String:Any]){
        if (dict["Link"] as? String) == nil{return nil}
        if (dict["Time"] as? Timestamp) == nil{return nil}
        if (dict["user"] as? String) == nil{return nil}

        self.link = dict["Link"] as! String
        self.time = (dict["Time"] as! Timestamp).dateValue()
        self.user = dict["user"] as! String
        self.userPhone = dict["userPhone"] as? String ?? ""
        self.userProfile = dict["userProfile"] as? String ?? ""
        self.widthImage = CGFloat(dict["width"] as? Double ?? 400.0)
        self.heightImage = CGFloat(dict["height"] as? Double ?? 400.0)
        self.loadState = .NOT_LOADED
    }
    
    func toDict(height: CGFloat, width: CGFloat)->[String:Any]{
        self.widthImage = width
        self.heightImage = height
        let retDict:[String:Any] = ["Link": self.link, "Time": self.time, "user": self.user, "userProfile": self.userProfile, "userPhone": self.userPhone, "index": self.localIndex, "width": self.widthImage, "height": self.heightImage]
        
        return retDict
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
}


protocol ChainImageDelegate {
    func imageDidLoad(chainImage: ChainImage)
}
