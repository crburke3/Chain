//
//  ExplorePageFireFuncs.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation

extension ExploreViewController{
    func loadTopChainIDs(chainNames: @escaping ([String])->()){
        masterFire.db.collection("explorePage").document("topChains").getDocument { (snap, err) in
            if err != nil{
                self.showPopUp(_title: "Error Loading", _message: "gotta check your internet conneciton bud."); return
            }
            if let snapData = snap!.data(){
                chainNames(snapData["chainNames"] as? [String] ?? [])
            }
        }
    }
    
    func loadGlobalChainsID(chains: @escaping ([PostChain])->()){
        //Only get docs of cells in view
        var chainArray = [PostChain]()
        
        masterFire.db.collection("globalFeed").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                chainArray.append(PostChain(dict: document.data() as [String : Any]))
            }
            chains(chainArray)
        }
        }
    }
    
    func loadUserFeed(chains: @escaping ([PostChain])->()){
           
        var chainArray = [PostChain]()
        masterFire.db.collection("users").document(currentUser.phoneNumber).collection("feed").getDocuments() { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
           } else {
               for document in querySnapshot!.documents {
                   chainArray.append(PostChain(dict: document.data() as [String : Any]))
            }
            chains(chainArray)
            }
            }
       }
}
