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
//        cell.selectionStyle = .none
//        let post = mainChain.posts[indexPath.row]
//        cell.setForPost(post: post)
//        return cell
        //------Mine is above ---
        if (indexPath.row == (self.mainChain.posts.count - 1)) && (mainChain.posts.count != 1) {
            //Load a post(s)

             if ((self.mainChain.posts.count - (self.tableView.indexPathsForVisibleRows?.last?.row ?? 0)) == 1) {
               mainChain.loadPost() { (post) in //chainSource -> global or general
                   if (post.link != "noLink") {
                    //self.mainChain.localAppend(post: post)
                        self.mainChain.localAppend(post: post)
                        self.mainChain.posts.last?.loadState = .LOADED
                        self.tableView.reloadData()
                   }
               }
            }
        }

        if (masterCache.allChains[0].posts.count <= (indexPath.row + 1)) {
            switch mainChain.posts[indexPath.row].loadState {
                case .NOT_LOADED:
                    if mainChain.posts.count == 1 { //For the first post only
                        mainChain.posts[0].loadState = .LOADED
                    }
                    cell.post = mainChain.posts[indexPath.row] //Should use post to extract all needed infromation for image
                    //Don't call Firestore if already in cache
                    print(self.tableView.indexPathsForVisibleRows?.last?.row) //Prints highest value

                    if ((self.mainChain.posts.count - (self.tableView.indexPathsForVisibleRows?.last?.row ?? 0)) <= 1) {
                        mainChain.loadPost() { (post) in //chainSource -> global or general
                            if (post.link != "noLink") {
                                self.mainChain.localAppend(post: post)
                                self.mainChain.posts.last?.loadState = .LOADED
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        print("L")
                    }
                    break
                case .LOADING:
                    //
                    cell.post = mainChain.posts[indexPath.row]
                    mainChain.posts[indexPath.row].loadState = .LOADED
                    break
                case .LOADED:
                    cell.isPostLoaded = true
                    break
            }
            var url = URL(string: self.mainChain.posts[indexPath.row].link) //Need to store dimensions in Firestore doc
            print("At \(indexPath.row) use \(self.mainChain.posts[indexPath.row].link)")
            cell.imgView.kf.setImage(with: url) { result in
            switch result {
                case .success(let value):
                    break
                case .failure(let error):
                    cell.imgView.image = UIImage(named: "fakeImg")!
                    print(error)
                    break
                }
            }
            //cell.share.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            cell.optionsMenu.addTarget(self, action: #selector(optionsClicked(sender:)), for: .touchUpInside)
            cell.user.text = self.mainChain.posts[indexPath.row].user
            cell.post = self.mainChain.posts[indexPath.row]
            cell.cellDidLoad()
            return cell
        } else { //In cahce, load cell from cache
             let url = URL(string: self.mainChain.posts[indexPath.row].link) //Need to store dimensions in Firestore doc
             cell.imgView.kf.setImage(with: url) { result in
                switch result {
                    case .success(let value):
                        break
                    case .failure(let error):
                        cell.imgView.image = UIImage(named: "fakeImg")!
                        print(error)
                        break
                    }
                }

            print("At \(indexPath.row) use \(self.mainChain.posts[indexPath.row].link)")
            //cell.share.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            cell.optionsMenu.addTarget(self, action: #selector(optionsClicked(sender:)), for: .touchUpInside)
            cell.user.text = self.mainChain.posts[indexPath.row].user
            cell.post = self.mainChain.posts[indexPath.row]
            cell.cellDidLoad()
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
            if (self.mainChain.posts[indexPath.row].heightImage == 0) && (self.mainChain.posts[indexPath.row].widthImage == 0) {
                self.mainChain.posts[indexPath.row].heightImage = 400
                self.mainChain.posts[indexPath.row].widthImage = 400
            }
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
