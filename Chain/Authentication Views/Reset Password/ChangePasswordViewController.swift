//
//  ChangePasswordViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/20/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func changePassword(_ sender: Any) {
        checkPasswordStrength()
        if confirmPassword.text == confirmPassword.text {
            masterAuth.changePassword(password: confirmPassword.text ?? "", phone: phone) { (error) in
                //
            }
        } else {
            return
        }
    }
    
    func checkPasswordStrength() {
        //List any criteria here
    }
    
}
