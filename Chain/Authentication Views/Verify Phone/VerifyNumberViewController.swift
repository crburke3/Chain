//
//  VerifyNumberViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/17/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import KKPinCodeTextField

class VerifyNumberViewController: UIViewController {
    
    let auth = ChainAuth()
    var phone: String = ""
    
    @IBOutlet weak var codeEntered: KKPinCodeTextField!
    @IBOutlet weak var verifyCode: UILabel!
    
    var signUpUser = ChainUser(_username: "", _phoneNumber: "", _name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyCode.text = "Sending verification code to:\n\(phone)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        if codeEntered.digitsCount == 6 {
            print("All digits entered (6)")
            //Verify
            auth.logInUser(verificationCode: codeEntered?.text ?? "", phone: phone, error: { error in
                if let error = error {
                    //Wrong code entered?
                    print(error)
                } else {
                }
            })
        } else {
            //Not all digits entered
            let alert = UIAlertController(title: "Alert", message: "Please enter the verification code", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
