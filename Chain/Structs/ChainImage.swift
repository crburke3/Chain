//
//  ChainImage.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class ChainImage{
    
    var delegate:ChainImageDelegate?
    
    func load(){
        //firestore pull initialization
        delegate?.imageDidLoad(chainImage: self)
        
    }
    
    
}


protocol ChainImageDelegate {
    func imageDidLoad(chainImage: ChainImage)
}
