//
//  LoadingView.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 2/18/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView{
    private var screenFrame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let spinner = UIActivityIndicatorView()
    var label = roundLabel()
    var backButton = RoundButton()
    var labelHeight:CGFloat = 30
    var labelWidth:CGFloat = UIScreen.main.bounds.width
    
    
    init(fullScreen:Bool = true){
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print(self.frame)
        setupView()
        //print(self.frame)
    }
    
    override func layoutSubviews() {
        refreshElementPosition()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
        backgroundColor = UIColor(red: 162/255, green: 163/255, blue: 1, alpha: 0.7)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        

        label = roundLabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: self.frame.width, height: labelHeight))
        label.center =  CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        label.cornerRadius = 5
        label.textAlignment = .center
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.numberOfLines = 0
        //label.backgroundColor = UIColor.white
        
        
        let btnHeight = CGFloat(25)
        let btnWidth = CGFloat(labelWidth)
        backButton = RoundButton(frame: CGRect(x: self.frame.midX - CGFloat(btnWidth/2), y: self.frame.midY - CGFloat((btnHeight/2) - 100), width: btnWidth, height: btnHeight))
        backButton.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backButton.setTitle("head back", for: .normal)
        backButton.backgroundColor = UIColor.black
        backButton.cornerRadius = 5
        backButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.addSubview(label)
        self.addSubview(spinner)
        //self.addSubview(backButton)
    }
    
    func refreshElementPosition(){
        label.center =  CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backButton.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spinner.frame = spinner.frame.offsetBy(dx: 0, dy: -40)  //Shift the spinner up 20 units
        print(label.frame)
    }
    
    func displayBackButton(_show:Bool){
        if(_show){
            self.addSubview(backButton)
        }else{
            backButton.removeFromSuperview()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.navigationController?.popViewController(animated: true)
        }
    }
}
