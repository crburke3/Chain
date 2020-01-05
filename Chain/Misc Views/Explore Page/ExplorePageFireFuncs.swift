//
//  ExplorePageFireFuncs.swift
//  Chain
//
//  Created by Christian Burke on 1/4/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation

extension ExploreViewController{
    func loadTopChainIDs(chainIDs: @escaping ([String])->()){
        masterFire.db.collection("explorePage").document("topChains").getDocument { (snap, err) in
            if err != nil{
                self.showPopUp(_title: "Error Loading", _message: "gotta check your internet conneciton bud."); return
            }
            if let snapData = snap!.data(){
                chainIDs(snapData["chainIDs"] as? [String] ?? [])
            }
        }
    }
}
