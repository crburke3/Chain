//
//  ChainCache.swift
//  Chain
//
//  Created by Michael Rutkowski on 2/11/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation


class ChainCache {
    
    var allChains:[PostChain] = []
    var sizeInBytes: Int = 0
    var sizeInPosts: Int = 0
    var cachePostLimit: Int = 40000 //Assuming each document is under 500 bytes
    //This will lead to around 20 Mb of data @ 40K posts
    //Seperate pod will handle image cacheing
    
    
    init() {
        allChains = []
    }
   
    func chainAlreadyLoaded(requestedChain: PostChain) -> Bool {
        for chain in allChains {
            if chain.chainUUID == requestedChain.chainUUID {
                return true
            }
        }
        return false
    }
    
    func postAlreadyLoaded(chainUUID: String, index: Int) -> Bool {
        var chainIndex: Int = 0
        for chain in allChains {
            if chainUUID == chain.chainUUID {
                break
            }
            chainIndex += 1
        }
        if allChains[chainIndex].highestViewedIndex <= index {
            return true
        }
        return false
    }
    
    func isAbleToTakeAnotherPost(sizeOfPost: Int) -> Bool {
        
        if ((self.sizeInPosts + 1) <= cachePostLimit) {
                return true
        } else {
                return false
            }
    }
    
    func reOrderCache(recentlyViewed: PostChain) {
        //Remove chain and place at top of cache
        var tempChain: PostChain
        var index = 0
        for chain in allChains {
            if chain.chainUUID == recentlyViewed.chainUUID {
                tempChain = allChains[index]
                allChains.remove(at: index)
                allChains.insert(tempChain, at: 0)
                break
            }
            index += 1
        }
        return
    }
    
    func deleteOldChain() {
        //Options:
        //  Delete posts until size is moderate
        //  Delete entire chains as a whole
    }
    
    func getSizeOfChain()  {
        //Update post and byte counts
        
    }
    
    func updateLimits() {
        //Based on user's phone, can adjust limits
        
    }
    
    
}
