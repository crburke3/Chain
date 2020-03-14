//
//  UIViewExtensions.swift
//  Chain
//
//  Created by Michael Rutkowski on 3/12/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
    }
    
}
