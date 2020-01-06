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
//import Geofirestore
import FirebaseAuth

class FirstViewController : UIViewController, CLLocationManagerDelegate{
    
    let phoneNumber = "+19802550653"
    let testVerificationCode = "123456"
    
    override func viewDidLoad() {
        //masterNav = self.navigationController! //Guessing you were trying to get the current Nav Controller
        masterStoryBoard = self.storyboard!
        
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        //Use performSegue instead
        performSegue(withIdentifier: "toMain", sender: self)
        //masterNav.pushViewController(mainVC, animated: true)
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
