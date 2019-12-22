//
//  GlobalAttributes.swift
//  FlexForum
//
//  Created by Christian Burke on 4/16/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class MyUILabel: UILabel {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLabel()
    }
    
    func configureLabel() {
        let globalFont = UIFont(name: "Arial", size: self.font.pointSize)
        font = globalFont
    }
    
}
