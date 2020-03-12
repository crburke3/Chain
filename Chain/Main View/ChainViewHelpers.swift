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

extension ChainViewController{
    func showOptionsPopup(post_row: Int, post_image: UIImage){
        let title = "Image Options"
        let message = "Select one of the actions below or press cancel"
        var postUser = ""
        let givenCell = self.tableView.cellForRow(at: IndexPath(row: post_row, section: 0)) as! MainCell
        let givenPost = givenCell.post.toDict(height: post_image.size.height, width: post_image.size.width) as [String:Any]
        postUser = givenPost["user"] as! String
        let indexPath = NSIndexPath(row: post_row, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        //Resize/Crop
        let image = cropToBounds(image: post_image, width: 100, height: 100)
        let popup = PopupDialog(title: title, message: message, image: image) //Image arguement is optional
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("Canceled")
        }
        /*
        let shareButton = DefaultButton(title: "Share Chain from this Image") {
            
            self.fpc = FloatingPanelController()
            self.fpc.delegate = self // Optional
            let contentVC = masterStoryBoard.instantiateViewController(withIdentifier: "UserMenuTableViewController") as! UserMenuTableViewController
            //Set conentVC array to hold currentUsers friends
            self.fpc.set(contentViewController: contentVC)
            self.fpc.track(scrollView: contentVC.tableView)
            self.fpc.isRemovalInteractionEnabled = true
            self.fpc.addPanel(toParent: self)
            
        }
        */
        let reportButton = DefaultButton(title: "Report Image", height: 60) {
            print("Report Image")
            masterFire.reportImage(chainName: self.mainChain.chainName, image: ChainImage(dict: givenPost)!) { (error) in
                if let error = error {
                    print(error)
                } else {
                    //Successfully reported
                }
            }
        }
        let removeButton = DefaultButton(title: "Remove your Image") {
            print("Photo: \(post_row)")
            print("Chain Removed")
            masterFire.removeFromChain(chainName: "firstChain", post: givenPost) { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("Post removed")
                }
            }
            self.tableView.reloadData()
        }
        //
        if postUser == "mbrutkow" {
            popup.addButtons([reportButton, removeButton, cancelButton])
        } else {
            popup.addButtons([reportButton, cancelButton])
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
        fanMenu.button = FanMenuButton(id: "Main", image: "infinity", color: .white)
        //fanMenu.
        fanMenu.interval = (1.25*(Double.pi), (1.75*(Double.pi))) //In radians
        //(0, -(Double.pi))
        //(1.25*(Double.pi), (1.75*(Double.pi)))
        fanMenu.menuBackground = .clear
        fanMenu.layer.backgroundColor = UIColor.clear.cgColor
        fanMenu.backgroundColor = UIColor.clear
        //May add append chain
        fanMenu.items = [
            FanMenuButton(
                id: "jumpToEnd",
                image: "end",
                color: .white
            ),
            FanMenuButton(
                id: "jumpToRandom",
                image: "random",
                color: .white
            ),
            FanMenuButton(
                id: "jumpToNextFriendsPost",
                image: "friends",
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
                    self.tableView.scrollToRow(at: IndexPath(row: Int.random(in: 0...(self.mainChain.posts.count-1)), section: 0), at: .middle, animated: true) //Might need to set to false
                    break
            case "jumpToEnd":
                print("Jumping to end of chain")
                self.tableView.scrollToRow(at: IndexPath(row: (self.mainChain.posts.count - 1), section: 0), at: .middle, animated: true)
                break
            case "jumpToNextFriendsPost":
                print("Finding next next friend's post")
                break
            default:
                break
            }
        
        }
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
}
