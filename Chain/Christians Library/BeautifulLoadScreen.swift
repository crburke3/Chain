//
//  BeautifulLoadScreen.swift
//  Brakez
//
//  Created by Christian Burke on 9/14/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit

class BeautifulLoadScreen: UIView {
    private var screenFrame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    public let spinner = CustomSpinner(frame: CGRect(x: 0, y: 0, width: 80, height: 80), image: UIImage(named: "Wheel")!)
    var label = roundLabel()
    var labelHeight:CGFloat = 30
    var labelWidth:CGFloat = UIScreen.main.bounds.width
    
    init(fullScreen:Bool = true){
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
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
    }
    
    //common func to init our view
    private func setupView() {
        setupBlur()
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
        //backgroundColor = UIColor(red: 162/255, green: 163/255, blue: 1, alpha: 0.7)
        spinner.rotate()
        
        label = roundLabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: self.frame.width, height: labelHeight))
        label.center =  CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 20)
        label.cornerRadius = 5
        label.textAlignment = .center
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.numberOfLines = 0
        
        self.addSubview(label)
        self.addSubview(spinner)
    }
    
    func refreshElementPosition(){
        label.center =  CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 20)
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
        print(label.frame)
    }
        
}
