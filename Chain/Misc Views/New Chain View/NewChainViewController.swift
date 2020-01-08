//
//  NewChainViewController.swift
//  Chain
//
//  Created by Christian Burke on 1/5/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Lottie

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
    @IBOutlet var animatorHolder: UIView!
    @IBOutlet var bottomLabel: UILabel!
    
    let submitLimit :CGFloat = 100
    var verticalLimit : CGFloat!
    var totalTranslation : CGFloat!
    var constraintHeight : CGFloat!
    var backgroundColor : UIColor!
    let colorSensitivity:CGFloat  = 2 //Lower = more change
    
    let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    var displayLink: CADisplayLink?

    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimatorView()
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
    
    func willPostChain(){
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop)
        let name = chainTitleField.text!
        let death = Date().add(days: 1)
        let tempTags = tagsField.text!.split(separator: " ")
        var tags:[String] = []
        for tag in tempTags{
            tags.append(String(tag))
        }
        let postChain = PostChain(_chainID: name, _birthDate: Date(), _deathDate: death!, _tags: tags)
        postChain.post { (err) in
            if err != nil{
                self.showPopUp(_title: "Error Posting Chain", _message: err!)
            }else{
                masterNav.popViewController(animated: false)
                masterNav.pushViewController(ChainViewController.initFrom(chain: postChain), animated: true)
            }
        }
    }
}
