//
//  ViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//
var globalRow: Int = 0
var globalImage = UIImage()

import UIKit
import PopupDialog

class MainViewController: UIViewController, ChainImageDelegate {

    var mainChain:PostChain!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timerLabel: UILabel!
    
    @IBAction func popUpMenu(_ sender: Any) {
        let title = "Image Options"
        let message = "Select one of the actions below or press cancel"
        print(globalRow)
        //Scroll and center cell
        let indexPath = NSIndexPath(row: globalRow, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        //Resize/Crop
        let image = cropToBounds(image: globalImage, width: 200, height: 200)
        let popup = PopupDialog(title: title, message: message, image: image) //Image arguement is optional
        // Create buttons
        let cancelButton = CancelButton(title: "CANCEL") {
            print("Canceled")
        }
        // This button will not the dismiss the dialog
        let shareButton = DefaultButton(title: "Share Chain from this Image") {
            print("Photo: \(globalRow)")
            print("Chain Shared!")
        }

        let reportButton = DefaultButton(title: "Report Image", height: 60) {
            print("Image Reported")
        }
        popup.addButtons([shareButton, reportButton, cancelButton])
        present(popup, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        masterFire.loadChain(chainID: "firstChain") { (loadedChain) in
            if let chain = loadedChain{
                self.mainChain = chain
                self.listenToDate()
                for post in self.mainChain.posts{
                    post.delegate = self
                }
                self.tableView.reloadData()
            }
        }

    }
    
    @IBAction func plusClicked(_ sender: Any) {
        //Load Global Object
        let cameraVC = CameraViewController()
        cameraVC.chainID = "firstChain" //Get chain ID from chain being viewed
        self.present(cameraVC, animated: true)
    }
    
    func imageDidLoad(chainImage: ChainImage) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: chainImage.localIndex, section: 0)], with: .fade)
        }
    }
    
    func listenToDate(){
        mainChain.deathDate.timeTillDeath { (timeLeft) in
            self.timerLabel.text = timeLeft
        }
    }

    func nextFewImages(chainID: String, currentIndex: Int, loadRadius: Int) {
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

extension MainViewController {
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
}
