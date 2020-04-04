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
import iOSPhotoEditor

class NewChainViewController: UIViewController, ChainCameraDelegate {
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
    @IBOutlet var textFields: [SkyFloatingLabelTextField]!
    
    let submitLimit :CGFloat = 85
    var verticalLimit : CGFloat!
    var totalTranslation : CGFloat!
    var constraintHeight : CGFloat!
    var backgroundColor : UIColor!
    let colorSensitivity:CGFloat  = 2 //Lower = more change
    var cameraVC:CameraViewController!
    var imageHolder: UIImage = UIImage()
    
    let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    var displayLink: CADisplayLink?

    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0

    var functionCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimatorView()
        let bottomPad = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        let topPad = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
        let screenHeight = UIScreen.main.bounds.height
        let effectiveScreen = screenHeight - (topPad + bottomPad)
        backButtonHeight.constant = effectiveScreen - (80 + 24) //button height + nice height
    }

    @objc func mainImageTapped(sender: Any){
        print("image tapped")
        cameraVC = CameraViewController()
        cameraVC.addDelegate(key: "NewChainViewController", delegate: self)
        masterNav.pushViewController(cameraVC, animated: true)
        //self.present(cameraVC, animated: true, completion: nil)
    }
    
    func didFinishImage(image: UIImage) {
        postImageView.image = image
        imageHolder = image
        masterNav.popViewController(animated: true)
    }

    @IBAction func cancelPressed(_ sender: Any) {
        swipeableView.isUserInteractionEnabled = true
        animateViewBackToLimit()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    
    func goodFields()->Bool{
        var isBad = false
        for field in textFields{
            if field.text == nil{
                isBad = true
            }
            if field.text!.count < 4{
                field.errorMessage = "Too Short"
                isBad = true
            }else{
                field.errorMessage = nil
            }
        }
        if postImageView.image == nil{
            isBad = true
        }
        if isBad{
            return false
        }else{
            return true
        }
    }
    
    
    func willPostChain(){
        if !goodFields(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.swipeableView.isUserInteractionEnabled = true
                self.animateViewBackToLimit()
            }
            return
        }
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop)
        functionCounter += 1
        print("\(functionCounter) Number of Times")
        if functionCounter == 1 {
            let name = chainTitleField.text!
            let death = Date().add(days: 4)
            let tempTags = tagsField.text!.split(separator: " ")
            var tags:[String] = []
            for tag in tempTags{
                tags.append(String(tag))
            }
            let postChain = PostChain(_chainName: name, _birthDate: Date(), _deathDate: death!, _tags: tags)
            if postImageView.image == nil{
                postChain.localAppend(post: ChainImage(image: UIImage(named: "fakeImg")!))
                postChain.posts[0].heightImage = 100
                postChain.posts[0].heightImage = 100
            }else{
                postChain.localAppend(post: ChainImage(image: postImageView.image!))
                postChain.posts[0].widthImage = imageHolder.size.width
                postChain.posts[0].heightImage = imageHolder.size.height
            }
              
            //Upload first image
            postChain.uploadChain() { (err) in
                if err != nil{
                    self.showPopUp(_title: "Error Uploading", _message: err!)
                    return
                }
                masterNav.popViewController(animated: false)
                masterNav.popViewController(animated: false)
                masterCache.addChainToCache(chain: postChain)
                masterNav.pushViewController(ChainViewController.initFrom(chain: postChain), animated: true)
            }
        }
    }
}
