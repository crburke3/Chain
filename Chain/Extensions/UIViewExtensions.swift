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
    func addShadowToUIView(offset: CGSize = CGSize.init(width: 0, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 4.0, opacity: Float = 0.35) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
