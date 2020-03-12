//
//  ExplorePageFireFuncs.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation

extension ExploreViewController{
    
    //Cache functions need serious help
    
    func loadGlobalChainsID(chains: @escaping ([PostChain])->()){
        //Add listener
        var chainArray = [PostChain]()
        
        masterFire.db.collection("globalFeed").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                chainArray.append(PostChain(dict: document.data() as [String : Any]))
                masterCache.allChains.append(PostChain(dict: document.data() as [String : Any]))
            }
            chains(chainArray)
        }
        }
    }
    
    func loadUserFeed(chains: @escaping ([PostChain])->()){
        //Add listener
        var chainArray = [PostChain]()
        //masterFire.db.collection("users").document(currentUser.phoneNumber).collection("feed").getDocuments()
        masterFire.db.collection("chains").getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
               for document in querySnapshot!.documents {
                   chainArray.append(PostChain(dict: document.data() as [String : Any]))
                   masterCache.allChains.append(PostChain(dict: document.data() as [String : Any]))
            }
            chains(chainArray)
            }
            }
       }
}
