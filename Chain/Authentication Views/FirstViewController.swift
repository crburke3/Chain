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
        masterNav = self.navigationController! //Guessing you were trying to get the current Nav Controller
        masterStoryBoard = self.storyboard!
        
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        currentUser.bio = "What's up guys!"
        currentUser.name = "Mike R"
        currentUser.username = "bigDawg"
        currentUser.blocked = []
        currentUser.invites = []
        currentUser.phoneNumber = "+19802550653"
        currentUser.profile = "https://firebasestorage.googleapis.com/v0/b/chain-3ad1e.appspot.com/o/Fitwork%20Images%2FD2F69E6E-47D8-4307-A91F-C4E1A737B3B1?alt=media&token=4fbfa3b6-c775-4935-b1de-ab12e98c940b"
        currentUser.topPosts = []
        //masterNav.pushViewController(SignInViewController(), animated: true)
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
        //mainVC.mainChain = PostChain(chainID: "firstChain", load: true)
        masterNav.pushViewController(mainVC, animated: true)
        /* let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
        mainVC.mainChain = PostChain(chainID: "firstChain", load: true)
        masterNav.pushViewController(mainVC, animated: true) //Push MainChain
        */
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
