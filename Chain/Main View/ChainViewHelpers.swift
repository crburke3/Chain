//
//  PopupMenuExtension.swift
//  Chain
//
//  Created by Christian Burke on 1/8/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import PopupDialog
import FloatingPanel
import FanMenu
import UIKit

extension ChainViewController{
    func showOptionsPopup(){
        let title = "Image Options"
        let message = "Select one of the actions below or press cancel"
        var postUser = ""
        //Resize/Crop
        let popup = PopupDialog(title: title, message: message) //Image arguement is optional
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("Canceled")
        }
        let reportButton = DefaultButton(title: "Report Image", height: 60) {
            print("Report Image")
            masterFire.reportImage(chainName: self.mainChain.chainName, image: self.mainChain.posts[(self.tableView.indexPathsForVisibleRows?.last!.row)!]) { (error) in
                if let error = error {
                    print(error)
                } else {
                    //Successfully reported
                }
            }
        }
        let removeButton = DefaultButton(title: "Remove your Image") {
            print("Chain Removed")
            masterFire.removeFromChain(chainName: "firstChain", post: self.mainChain.posts[(self.tableView.indexPathsForVisibleRows?.last!.row)!].toDict()) { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("Post removed")
                }
            }
            self.tableView.reloadData()
        }
        let shareButton = DefaultButton(title: "Share from Post") {
            self.shareFromPost(index: (self.tableView.indexPathsForVisibleRows?.last!.row)!) //Needs index
        }
        //
        if postUser == currentUser.phoneNumber {
            popup.addButtons([shareButton, reportButton, removeButton, cancelButton])
        } else {
            popup.addButtons([shareButton, reportButton, cancelButton])
        }
        present(popup, animated: true, completion: nil)
    }
    
    static func initFrom(chain: PostChain)->ChainViewController{
        let vc = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
        vc.mainChain = chain
        return vc
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
 
    
    func reloadChain(){
        tableView.cr.endHeaderRefresh()
        /*
        mainChain.loadPost { (err) in
            if err != nil{
                print(err!); return
            }
            self.listenToDate()
            for post in self.mainChain.posts{
                post.delegate = self
            }
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
        }
         */
    }
    
    func fanMenuSetUp() {
        fanMenu.button = FanMenuButton(id: "Main", image: "smallImg", color: .white)
        fanMenu.menuRadius = 70.0
        fanMenu.radius = 20.0 //Controls button radius
        fanMenu.duration = 0.35
        fanMenu.interval = (0.75*(Double.pi), (1.25*(Double.pi))) //In radians
        fanMenu.menuBackground = .clear
        fanMenu.layer.backgroundColor = UIColor.clear.cgColor
        fanMenu.backgroundColor = UIColor.clear
        //Image("room.thumbnailImage").resizable().frame(width: 32.0, height: 32.0)
        //24x24 pixel images work well with 20 button radius
        fanMenu.items = [
            FanMenuButton(
                id: "jumpToEnd",
                image: "smallImg",
                color: .white
            ),
            FanMenuButton(
                id: "jumpToRandom",
                image: "smallImg",
                color: .white
            ),
            FanMenuButton(
                id: "jumpToNextFriendsPost",
                image: "smallImg",
                color: .white
            )
        ]
        
        fanMenu.onItemDidClick = { button in
            //print("ItemDidClick: \(button.id)")
            switch button.id {
                case "addPhotoToChain":
                    print("Adding photo")
                    break
                case "jumpToRandom":
                    print("Jumping to random position in chain")
                    //Show animation of some sort here
                    self.tableView.scrollToRow(at: IndexPath(row: Int.random(in: 0...(self.mainChain.posts.count-1)), section: 0), at: .middle, animated: false) //Might need to set to false
                    break
            case "jumpToEnd":
                print("Jumping to end of chain")
                //Show annimation of some sort here
                self.tableView.scrollToRow(at: IndexPath(row: (self.mainChain.posts.count - 1), section: 0), at: .middle, animated: false)
                break
            case "jumpToNextFriendsPost":
                print("Finding next next friend's post")
                //
                let currentlyViewedIndex = self.tableView.indexPathsForVisibleRows?.last?.row ?? 0
                for index in (currentlyViewedIndex+1...self.mainChain.posts.count-1) {
                    if self.aPostByFriend(phone: self.mainChain.posts[index].userPhone) {
                        self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: false) //Jump to post
                        break //Exit loop
                    }
                }
                break
            default:
                break
            }
        
        }
    }
    
    func aPostByFriend(phone: String) -> Bool {
        for friend in currentUser.friends {
            if friend.phoneNumber == phone { //Is there a faster way to do this
                return true
            }
        }
        return false
    }
    
    func listenToDate(){
        mainChain.deathDate.timeTillDeath { (timeLeft) in
            self.timerLabel.text = timeLeft
        }
    }
    
    func nextFewImages(chainName: String, currentIndex: Int, loadRadius: Int) {
        //indexPathsForVisibleItems -> Collection View
        //indexPathsForVisibleRow -> Table View
        let upperIndex = currentIndex + loadRadius
        var newIndex = currentIndex + 1
        while (newIndex < upperIndex) {
            //KingFisher load function
            newIndex += 1
        }
    }
    
    @objc func optionsClicked(sender: UIButton) {
        //Present menu
        self.showOptionsPopup()
    }
}
