//
//  FirstView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Geofirestore

class FirstViewController : UIViewController, CLLocationManagerDelegate{
    
    override func viewDidLoad() {
        masterNav = self.navigationController!
        masterStoryBoard = self.storyboard!
        
        if let phoneNumber = loadString(ident: .phoneNumber){
            //Try and log in automatically
            ChainUser.initFromFirestore(with: phoneNumber) { (loadedUser) in
                if let user = loadedUser{
                    masterAuth.currUser = user
                }
            }
        }
        
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        masterNav.pushViewController(mainVC, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .restricted: break
        case .denied:
            NSLog("do some error handling")
            break
        default:
            masterLocator.startUpdatingLocation()
        }
    }
    
}
