//
//  ExplorePageFireFuncs.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import Firebase

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
                //masterCache.allChains.append(PostChain(dict: document.data() as [String : Any]))
            }
            chains(chainArray)
        }
        }
    }
    
    func loadUserFeed(returnNumber: Int, chains: @escaping ([PostChain])->()){
        //Add listener
        var chainArray = [PostChain]()
        //masterFire.db.collection("users").document(currentUser.phoneNumber).collection("feed").getDocuments()
        masterFire.db.collection("chains").whereField("birthDate", isGreaterThan: masterFire.lastReadTimestamp).limit(to: returnNumber).getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
               for document in querySnapshot!.documents {
                    chainArray.append(PostChain(dict: document.data() as [String : Any]))
                masterFire.deleteChainFromFirestore(path: "general", chain: document.get("chainUUID") as! String, user: currentUser.phoneNumber, deathDate: document.get("deathDate") as! Timestamp)
                    masterFire.lastReadTimestamp = document.get("birthDate") as! Timestamp
                   //masterCache.allChains.append(PostChain(dict: document.data() as [String : Any]))
                }
            chains(chainArray)
            }
        }
    }
    
    func loadFriendsFeed(returnNumber: Int, chains: @escaping ([PostChain])->()){
     //Add listener
        var chainArray = [PostChain]()
        masterFire.db.collection("users").document(currentUser.phoneNumber).collection("feed").whereField("birthDate", isGreaterThan: masterFire.lastReadTimestamp).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    chainArray.append(PostChain(dict: document.data() as [String : Any]))
                    masterFire.lastReadTimestamp = document.get("birthDate") as! Timestamp
                    //masterCache.allChains.append(PostChain(dict: document.data() as [String : Any]))
                }
             chains(chainArray)
             }
         }
    }
    
    func loadChainPreviewForVisibleCell() {
        self.collectionViewA.indexPathsForVisibleItems
        self.collectionViewA.reloadData()
    }
    
}
