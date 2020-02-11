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

extension ChainViewController: UITableViewDataSource, UITableViewDelegate{

    
    
    //Function to be called upon share button press
    
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! MainCell
        //
        let post = ChainImage(image: UIImage())
        
        //Get data from previous query then call the next
        
        nextQuery = masterFire.db.collection("cities").order(by: "Time").start(afterDocument: lastDoc!).limit(to: 1)
        //Get data from nextQuery
        nextQuery?.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        post.user = document.get("user") as? String ?? ""
                        post.link = document.get("Link") as? String ?? ""
                        post.time = ((document.get("Time") as? Timestamp)?.dateValue())!
                        post.userPhone = document.get("userPhone") as? String ?? ""
                        post.userProfile = document.get("userProfile") as? String ?? ""

                    }
                }
        }
        nextQuery?.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving post: \(error.debugDescription)")
                return
            }

            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                return
            }
            self.lastDoc = lastSnapshot
        }
        //Set link for post
        
        cell.user.text = post.user
        cell.imgView.image = post.image
        cell.imgView.roundCorners(corners: [.allCorners], radius: 5)
        cell.row = indexPath.row
        cell.post = post
        //
        let url = URL(string: mainChain.posts[indexPath.row].userProfile)
        cell.profilePicImage?.kf.setImage(with: url)
        cell.phone = mainChain.posts[indexPath.row].userPhone
        //cell.profilePic.image = UIImage()
        cell.profilePicImage.layer.borderWidth = 1
        cell.profilePicImage.layer.masksToBounds = false
        cell.profilePicImage.layer.borderColor = UIColor.black.cgColor
        cell.profilePicImage.layer.cornerRadius = cell.profilePicImage.frame.height/2
        cell.profilePicImage.clipsToBounds = true
        cell.profilePicImage.contentMode = .scaleAspectFill
        //
        //cell.profilePic.imageView?.kf.setImage(with: <#T##ImageDataProvider?#>)
        switch post.loadState{
        case .NOT_LOADED:
            //Set URL
            //post.url
            post.load() //If cell hasn't been loaded yet, then query post from Firestore
        case .LOADING:
            break
        case .LOADED:
            cell.isPostLoaded = true
        }
        
        cell.share.tag = indexPath.row
        cell.share.addTarget(self, action: #selector(ChainViewController.buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        
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
    //Currently posts are in dict and don't need to be queried
    //Switching to sub-collection and posts need to be queried as their respective cells become visible
    
    
}
