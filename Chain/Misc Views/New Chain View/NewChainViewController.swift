//
//  NewChainViewController.swift
//  Chain
//
//  Created by Christian Burke on 1/5/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class NewChainViewController: UIViewController {

    @IBOutlet var chainTitleField: SkyFloatingLabelTextField!
    @IBOutlet var tagsField: SkyFloatingLabelTextField!
    @IBOutlet var deathDateField: SkyFloatingLabelTextField!
    @IBOutlet var imageHolderView: RoundView!
    @IBOutlet var cameraIconView: UIImageView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var swipeableView: UIView!
    @IBOutlet var swipeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var swipeToPostLabel: UILabel!
    @IBOutlet var backButtonHeight: NSLayoutConstraint!
    
    
    let submitLimit :CGFloat = 100
    var verticalLimit : CGFloat!
    var totalTranslation : CGFloat!
    var constraintHeight : CGFloat!
    var backgroundColor : UIColor!
    let colorSensitivity:CGFloat  = 2 //Lower = more change
    
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonHeight.constant = view.frame.height  - 280
        backgroundColor = view.backgroundColor!
        if backgroundColor.getHue(&h, saturation: &s, brightness: &b, alpha: nil) {
            
        } else {
            print("Failed with color space")
        }
        swipeableView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 5)
        swipeableView.addObserver(self, forKeyPath:"frame", options:.new, context:nil)

        constraintHeight = swipeHeightConstraint.constant
        verticalLimit = constraintHeight
        totalTranslation = constraintHeight

        imageHolderView.addShadow()
        
        let panGestureRecognizer = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        swipeableView.addGestureRecognizer(panGestureRecognizer)
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainImageTapped(sender:))))
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //print("value of \(keyPath) changed: \(change![keyPath!])")

    }
    
    @objc func mainImageTapped(sender: Any){
        print("image tapped")
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        swipeableView.isUserInteractionEnabled = true
        animateViewBackToLimit()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
}
