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
import FirebaseAuth

class FirstViewController : UIViewController, CLLocationManagerDelegate{
    
    let phoneNumber = "+19802550653"
    let testVerificationCode = "123456"
    
    override func viewDidLoad() {
        masterNav = self.navigationController!
        masterStoryBoard = self.storyboard!
        
        //Verify
         Auth.auth().languageCode = "en"; //Set language
        //Send Verification code
         PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
           if let error = error {
             print(error.localizedDescription)
            print("Not working")
             return
           }
           // Sign in using the verificationID and the code sent to the user
           // ...
            print("Verification Code: \(verificationID ?? "None")")
             UserDefaults.standard.set(verificationID, forKey: "authVerificationID") //Save verification ID
             
         }
        
         let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
         
         
         let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: testVerificationCode) //Load object
         //Sign In
         Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
           if let error = error {
             // ...
             return
           }
           // User is signed in
           // ...
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
