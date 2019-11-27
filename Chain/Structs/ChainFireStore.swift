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

class ChainFireStore {
    //
    let locationManager = CLLocationManager()
    
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
    
    //TODO: Make better chain function
    //Will user for good, could return a lot of IDs, we can paginate this also, which we will need to do
//    func loadChainIDs(){
//
//    }
    
}
