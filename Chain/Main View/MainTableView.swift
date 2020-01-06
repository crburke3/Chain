//
//  MainCollectionView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        let post = mainChain.posts[indexPath.row]
        cell.user.text = post.user
        cell.imgView.image = post.image
        cell.imgView.roundCorners(corners: [.allCorners], radius: 5)
        cell.row = indexPath.row
        switch post.loadState{
        case .NOT_LOADED:
            post.load()
        case .LOADING:
            break
        case .LOADED:
            break
        }
        cell.cellDidLoad()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainChain == nil{
            return 0
        }
        return mainChain.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        return cell.frame.height
    }
    
    
}
