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
        let ref = masterFire.db.collection("chains").whereField("isGlobal", isEqualTo: true).limit(to: 25)
        ref.getDocuments { (snap, err) in
            guard let docs = snap?.documents else{ chains([]); return }
            var chainArray = [PostChain]()
            for document in docs {
                chainArray.append(PostChain(dict: document.data() as [String : Any])!)
            }
            chains(chainArray)
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
                let chain = PostChain(dict: document.data() as [String : Any])!
                chainArray.append(chain)
//                masterFire.deleteChainFromFirestore(chain: chain) { (err) in
//
//                }
                }
                chains(chainArray)
            }
        }
    }
    
    func loadFriendsFeed(returnNumber: Int, chains: @escaping ([PostChain])->()){
     //Add listener
        var chainArray = [PostChain]()
        masterFire.db.collection("users").document(masterAuth.currUser.phoneNumber).collection("feed").whereField("birthDate", isGreaterThan: masterFire.lastReadTimestamp).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    chainArray.append(PostChain(dict: document.data() as [String : Any])!)
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
