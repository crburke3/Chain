//
//  UserHeaderView.swift
//  Chain
//
//  Created by Christian Burke on 3/20/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class UserHeaderView:UIView{
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var specialHeight: NSLayoutConstraint!
    
    private let colorSensitivity:CGFloat  = 80 //Lower = more change
    private var h: CGFloat = 0
    private var s: CGFloat = 0
    private var b: CGFloat = 0
    
    override var bounds: CGRect{
        didSet{
            let height = self.bounds.height
            let posPercent = abs((height) / colorSensitivity)
            let hueVal = h  * posPercent
            self.imgView.roundCorners(corners: [.allCorners], radius: height/2)
            self.contentView.backgroundColor = UIColor(hue: hueVal, saturation: s, brightness: b, alpha: 1.0)
            //bottomLabel.textColor = UIColor.darkGray.withAlphaComponent(posPercent)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("UserHeaderView", owner: self, options: nil)
        addSubview(contentView)
        //contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 30)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.constrainToSuperview()
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.Chain.lightTan
        if contentView.backgroundColor!.getHue(&h, saturation: &s, brightness: &b, alpha: nil) {
            print("got it")
        } else {
            print("Failed with color space")
        }
    }
    
}
