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

class ChainImage{
    
    var link:String
    var user:String
    var time:String
    var image:UIImage?
    var loadState = LoadState.NOT_LOADED
    var delegate:ChainImageDelegate?
    var localIndex:Int = 0
    
    //When created by user locally after image is uploaded
    init(link:String, user:String, image:UIImage){
        self.loadState = .LOADED
        self.image = image
        self.link = link
        self.user = user
        self.time = Date().toChainString() //Convert to string
    }
    
    /// Local Init, the user will need to be very careful using this. Make sure you upload it to the chain
    /// - Parameter image: the image to be posted
    init(image:UIImage){
        self.loadState = .NOT_LOADED
        self.image = image
        self.link = ""
        self.user = ""
        self.time = Date().toChainString()
    }
    
    //When pulled from firestore
    init?(dict:[String:Any]){
        if (dict["Link"] as? String) == nil{return nil}
        if (dict["Time"] as? String) == nil{return nil}
        if (dict["user"] as? String) == nil{return nil}

        self.link = dict["Link"] as! String
        self.time = dict["Time"] as! String
        self.user = dict["user"] as! String
    }
    
    func toDict()->[String:Any]{
        let retDict:[String:Any] = ["Link": self.link,
                                    "Time": self.time,
                                    "user": self.user]
        return retDict
    }
    
    func load(){
        if (loadState == .LOADING) || (loadState == .LOADED){
            return
        }
        //firestore pull initialization
        self.loadState = .LOADING
        //print("Downloading: \(self.link)")
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
