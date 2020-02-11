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
import Pastel


class FirstViewController : UIViewController, CLLocationManagerDelegate{
    
    let phoneNumber = "+19802550653"
    let testVerificationCode = "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masterNav = self.navigationController! //Guessing you were trying to get the current Nav Controller
        masterStoryBoard = self.storyboard!
        addGradient()
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
        //let x = 100
       //let s = MemoryLayout.size(ofValue: x)
        //let string = "aaabbccddeeffgghh"
        //let object = MemoryLayout.size(ofValue: string)
        //let size = MemoryLayout<PostChain>.size
        //print("Size of number is \(size)")
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
        //mainVC.mainChain = PostChain(chainName: "firstChain", load: true)
        masterNav.pushViewController(mainVC, animated: true)
        /* let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
        mainVC.mainChain = PostChain(chainName: "firstChain", load: true)
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
    
    func addGradient(){
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor.Chain.mainBlue,
                              UIColor.Chain.mainOrange])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
}
