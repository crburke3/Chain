//
//  SignUpViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    let auth = ChainAuth()
    
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField?
    @IBOutlet weak var fullName: SkyFloatingLabelTextField?
    @IBOutlet weak var userName: SkyFloatingLabelTextField?
    @IBOutlet weak var verificationCode: SkyFloatingLabelTextField?
    
    @IBAction func signUp(_ sender: Any) {
        auth.sendVerificationCode(phoneNumber: "+19802550653", error: { error in
            if let error = error {
                print(error)
            } else {
                //Segue to next view to enter code
            }
        })
    }
    
    @IBAction func verifyAccount(_ sender: Any) {
        auth.verifyCode(verificationCode: verificationCode?.text ?? "", error: { error in
            if let error = error {
                print(error)
            } else {
                //Segue to main once verified
            }
        })
        //performSegue(withIdentifier: "signUpToMain".. once complete
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    

}
