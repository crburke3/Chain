//
//  MainCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

extension ChainViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        //Check to see if masterCache.allChains[0].posts[indexPath.row] exists
        if (masterCache.allChains[0].posts.count <= (indexPath.row + 1)) {
            switch mainChain.posts[indexPath.row].loadState {
                case .NOT_LOADED:
                    if mainChain.posts.count == 1 { //For the first post only
                        mainChain.posts[0].loadState = .LOADED
                    }
                    cell.post = mainChain.posts[indexPath.row] //Should use post to extract all needed infromation for image
                    //Don't call Firestore if already in cache
                    mainChain.loadPost(postSource: self.chainSource) { (post) in //chainSource -> global or general
                        if (post.link != "noLink") {
                            self.mainChain.posts.append(post)
                            //self.mainChain.posts[indexPath.row].heightImage //Get heigh and width of image
                            let url = URL(string: self.mainChain.posts[indexPath.row].link) //Need to store dimensions in Firestore doc
                            cell.imgView.kf.setImage(with: url) { result in
                                switch result {
                                case .success(let value):
                    
                                    break
                                case .failure(let error):
                                    print(error)
                                    break
                                }
                            }
                            //
                            self.mainChain.posts[indexPath.row].loadState = .LOADED
                            self.tableView.reloadData()
                    }
                }
                    break
                case .LOADING:
                    break
                case .LOADED:
                    cell.isPostLoaded = true
            }
            return cell
        } else { //In cahce, load cell from cache
             let url = URL(string: self.mainChain.posts[indexPath.row].link) //Need to store dimensions in Firestore doc
             cell.imgView.kf.setImage(with: url) { result in
                switch result {
                    case .success(let value):
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainChain == nil{
            return 0
        }
        return mainChain.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = mainChain.posts[indexPath.row]
        if post.loadState == .LOADED{
            let aspectRatio = self.mainChain.posts[indexPath.row].heightImage / self.mainChain.posts[indexPath.row].widthImage
            let cellWidth = UIScreen.main.bounds.width - (24 * 2)
            let imgHeight = cellWidth * aspectRatio
            print(imgHeight)
            return imgHeight //+ 16 + 8 + (24 * 2)
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        return cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fpc != nil {
            self.fpc.removePanelFromParent(animated: true)
            print("Removing Menu")
        } else {
            print("Menu not set yet")
        }
    }
    //Currently posts are in dict and don't need to be queried
    //Switching to sub-collection and posts need to be queried as their respective cells become visible
    
    
}
