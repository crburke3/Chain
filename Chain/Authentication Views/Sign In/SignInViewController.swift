//
//  SignInViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class SignInViewController: UIViewController {
    
    let auth = ChainAuth()
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField?
    @IBOutlet weak var verificationCode: SkyFloatingLabelTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func formatPhone() -> String {
        return "1+\(phoneNumber?.text ?? "")" //Will vary by country
    }
    
    @IBAction func sendCode(_ sender: Any) {
        auth.sendVerificationCode(phoneNumber: formatPhone(), error: { error in
        if let error = error {
            print(error)
        } else {
            
        }
    })
    }
    @IBAction func signIn(_ sender: Any) {
        auth.logInUser(verificationCode: verificationCode?.text ?? "", error: { error in
            if let error = error {
                print(error)
            } else {
                //getCurUserInfo()
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        })
    }
    
}
