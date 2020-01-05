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
import Geofirestore


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
    
    init(_chainID:String, _birthDate:Date, _deathDate:Date, _tags:[String]?, firstImageLink:String, firstImage:UIImage){
        self.chainID = _chainID
        self.birthDate = _birthDate
        self.deathDate = _deathDate
        self.likes = 0
        self.count = 1
        self.tags = _tags ?? []
        self.contributors = [masterAuth.currUser.username]
        self.coordinate = masterLocator.getCurrentLocation()!.coordinate
        self.posts = [ChainImage(link: firstImageLink, user: masterAuth.currUser.username, image: firstImage)]
        self.loaded = .LOADED
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
            self.posts.append(ChainImage(dict: postData))
        }
        let latLong = dict["l"] as! [Double]
        self.coordinate = CLLocationCoordinate2D(latitude: latLong[0], longitude: latLong[1])
        self.loaded = .LOADED
    }
    
    func toDict()->[String:Any]{
        
        let geoData = GeoFirestore.getFirestoreData(for: self.coordinate)!
        
        let retDict:[String:Any] = ["chainID" : self.chainID,
                                    "birthDate" : self.birthDate.toChainString(),
                                    "deathDate" : self.deathDate.toChainString(),
                                    "likes" : self.likes,
                                    "count": self.count,
                                    "tags" : self.tags,
                                    "contributors" : self.contributors,
                                    "posts": self.postsData(),
                                    "l" : geoData["l"] as! [Double],
                                    "g" : geoData["g"] as! String]
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
    
    
    //TODO: Make load function
//    func load(){
//
//    }
}

protocol PostChainDelegate {
    func chainDidLoad(chain: PostChain)
}

/*
extension CLLocationManager{
    func getCurrentLocation()->CLLocation?{
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            if let appleLocation = self.location{
                return appleLocation
            }
        }else{
            print("user has not authorized location management")
        }
        return nil
    }
}
 */
/*
extension GeoFirestore{
    public static func getFirestoreData(for coordinate: CLLocationCoordinate2D)->[String:Any]?{
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        if let geoHash = GFGeoHash(location: coordinate).geoHashValue {
    return ["l" : [lat,lon], "g": geoHash]
        }
        return nil
    }
}

*/

