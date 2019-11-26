//
//  FirstView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class FirstViewController : UIViewController{
    
    override func viewDidLoad() {
        masterNav = self.navigationController!
        masterStoryBoard = self.storyboard!
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        masterNav.pushViewController(mainVC, animated: true)
    }
}
