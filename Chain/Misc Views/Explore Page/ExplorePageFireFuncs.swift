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
        masterFire.lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))
        //masterFire.db.collection("users").document(currentUser.phoneNumber).collection("feed").getDocuments()
        masterFire.db.collection("chains").whereField("birthDate", isGreaterThan: masterFire.lastReadTimestamp).limit(to: returnNumber).order(by: "birthDate", descending: false).getDocuments() { (querySnapshot, err) in
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
       //Switch currentChains to feed once done testing
        masterFire.lastReadTimestamp = Timestamp(date: Date(timeIntervalSinceReferenceDate: -123456789.0))
        masterFire.db.collection("users").document(masterAuth.currUser.phoneNumber).collection("currentChains").whereField("birthDate", isGreaterThan: masterFire.lastReadTimestamp).limit(to: returnNumber).order(by: "birthDate", descending: false).getDocuments() { (querySnapshot, err) in
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
    
    func changeFeed() { //Called once swipe gesture is performed
        if self.currentFeed == .FriendsFeed {
            self.currentFeed = .GeneralFeed
            loadUserFeed(returnNumber: 4) { (chains) in
                for chain in chains{
                    chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                    masterCache[chain.chainUUID] = chain
                }
                self.otherChains = chains
                print("Retrieved User Feed")
                self.collectionViewA.reloadData() //A is bottom collection view
            }
        } else {
            self.currentFeed = .FriendsFeed
            loadFriendsFeed(returnNumber: 4) { (chains) in
                for chain in chains{
                    chain.addDelegate(delegateID: "ExploreViewController", delegate: self)
                    masterCache[chain.chainUUID] = chain
                }
                self.otherChains = chains
                print("Retrieved Friends Feed")
                self.collectionViewA.reloadData() //A is bottom collection view
            }
        }
    }
    
}
