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
    var cacheByteLimit: Int = 25000000 //25 Mb
    var timer = Timer()
    
    init() {
        allChains = [PostChain(chainUUID: "1b0LCcjiVh53Kb89xD8Q")]
        allChains[0].load { (err) in}
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkChainsDeathDate), userInfo: nil, repeats: true)
    }
    
    @objc func checkChainsDeathDate(){
        for chain in allChains{
            if chain.deathDate < Date() && chain.isDead == false{
                chain.isDead = true
                print("killing chain: \(chain.chainName)")
                for delegate in chain.delegates.values{
                    delegate.chainDidDie(chain: chain)
                }
                
//                masterFire.deleteChainFromFirestore(chain: chain) { (err) in
//                    print(err)
//                }
            }
        }
    }
    
    subscript(chainUUID: String)->PostChain{
        set(newValue){
            var existIndex:Int? = nil
            var counter = 0
            for chain in allChains{
                if chain.chainUUID == chainUUID{
                    existIndex = counter
                }
                counter += 1
            }
            if existIndex != nil{
                allChains[existIndex!] = newValue
            }else{
                allChains.append(newValue)
            }
        }
        get{
            for chain in allChains {
                if chain.chainUUID == chainUUID {
                    return chain
                }
            }
            let newChain = PostChain(chainUUID: chainUUID)
            allChains.append(newChain)
            return newChain
        }
    }
   
    func chainAlreadyLoaded(requestedChain: PostChain) -> Bool {
        if allChains.count == 0{return false}
        for chain in allChains {
            if chain.chainUUID == requestedChain.chainUUID {
                return true
            }
        }
        return false
    }
    
    func postAlreadyLoaded(chainUUID: String, birthDate: Date) -> Bool {
        /* var chainIndex: Int = 0
        for chain in allChains {
            if chainUUID == chain.chainUUID {
                break
            }
            chainIndex += 1
        } */
        if self.allChains[0].lastReadBirthDate >= birthDate {
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
    
    func addChainToCache(chain: PostChain) {
        if !chainAlreadyLoaded(requestedChain: chain) {
            self.allChains.append(chain)
        }
        checkSizeOfChain()
    }
    
    func addPostToCache(chainUUID: String, birthDate: Date, post: ChainImage) {
        //Viewed chain should be in first index of allChains
        if !postAlreadyLoaded(chainUUID: chainUUID, birthDate: birthDate) {
            self.allChains[0].localAppend(post: post)
            self.allChains[0].lastReadBirthDate = post.time
            self.sizeInPosts += 1
            self.checkSizeOfChain()
        }
    }
    func deleteOldChain() {
        //Options:
        print("Freeing up space in cache")
        //  Delete posts until size is moderate
        //  Delete entire chains as a whole
    }
    
    func checkSizeOfChain()  {
        //Update post and byte counts
        //300 is estimated size of Chain
        //500 is estimated size of Post
        self.sizeInBytes = (self.sizeInPosts*500) + (self.allChains.count*300)
        if (self.sizeInBytes > self.cacheByteLimit || self.sizeInPosts > self.cachePostLimit) {
            deleteOldChain()
        }
    }
    
    func updateLimits() {
        //Based on user's phone, can adjust limits
        
    }
    
    
}
