//
//  BeautifulLoadScreen.swift
//  Brakez
//
//  Created by Christian Burke on 9/14/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import Lottie

class BeautifulLoadScreen: UIView {
    private var screenFrame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    public let spinner = CustomSpinner(frame: CGRect(x: 0, y: 0, width: 80, height: 80), image: UIImage(named: "Wheel")!)
    var label = roundLabel()
    var labelHeight:CGFloat = 30
    var labelWidth:CGFloat = UIScreen.main.bounds.width
    var animView = AnimationView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    init(lottieAnimation:LottieAnimations){
        super.init(frame: UIScreen.main.bounds)
        setupLottie(animName: lottieAnimation.rawValue)
    }
    
    init(fullScreen:Bool = true){
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshElementPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupBlur(){
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = .black
        }
        
        label = roundLabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: self.frame.width, height: labelHeight))
        label.cornerRadius = 5
        label.textAlignment = .center
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.numberOfLines = 0
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        guard let customFont = UIFont(name: "ChaloopsW00-Reg", size: UIFont.labelFontSize) else {return}
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
    }
    
    //common func to init our view
    private func setupView() {
        setupBlur()
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
        spinner.rotate()
        self.addSubview(spinner)
    }
    
    func refreshElementPosition(){
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
    }
        
    func setupLottie(animName:String){
        setupBlur()
        if let animation = Animation.named(animName, subdirectory: nil){
            animView.animation = animation
            animView.contentMode = .scaleAspectFit
        }else{
            print("couldnt find the animation!")
        }
        self.addSubview(animView)
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 16).isActive = true
        animView.backgroundBehavior = .pauseAndRestore
        animView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
    }
    
}

enum LottieAnimations:String{
    case FluffLoading = "FluffLoading"
    case FluffLoadingColored = "FluffLoadingColored"
    case ChainBreak = "ChainBreak"
    case UglyChain = "uglyChain"
}
