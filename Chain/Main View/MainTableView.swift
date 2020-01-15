//
//  MainCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension ChainViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        let post = mainChain.posts[indexPath.row]
        cell.user.text = post.user
        cell.imgView.image = post.image
        cell.imgView.roundCorners(corners: [.allCorners], radius: 5)
        cell.row = indexPath.row
        cell.post = post
        switch post.loadState{
        case .NOT_LOADED:
            post.load()
        case .LOADING:
            break
        case .LOADED:
            cell.isPostLoaded = true
        }
        cell.backView.addShadow()
        return cell
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
            //Aspect = height/width
            let aspectRatio = post.image!.size.height/post.image!.size.width
            let cellWidth = UIScreen.main.bounds.width - (24 * 2)
            let imgHeight = cellWidth * aspectRatio
            return imgHeight + 16 + 8 + (24 * 2)
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
    
}
