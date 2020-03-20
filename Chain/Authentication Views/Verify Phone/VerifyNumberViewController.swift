//
//  VerifyNumberViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/17/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import KKPinCodeTextField
import FirebaseAuth
import Firebase
import FirebaseFirestore

class VerifyNumberViewController: UIViewController {
    
    let auth = ChainAuth()
    var phone: String = ""
    var delegates:[String:VerifyNumberViewControllerDelegate] = [:]
    
    @IBOutlet weak var codeEntered: KKPinCodeTextField!
    @IBOutlet weak var verifyCode: UILabel!
    @IBOutlet var submitButton: RoundButton!
    
    convenience init(phoneNumber:String) {
        self.init()
        self.phone = phoneNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyCode.text = "Sending verification code to:\n\(phone)"
        // Do any additional setup after loading the view.
        //Send message when view loaded
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                return
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID") //Save verification code
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        submitButton.startSpinner()
        if codeEntered.digitsCount == 6 {
            print("All digits entered (6)")
                auth.verifyCode(verificationCode: codeEntered?.text ?? "", error: { error in
                    self.submitButton.stopSpinner()
                    if let error = error {
                        self.dismissAndFail()
                        print(error)
                    } else {
                        self.dismissAndSuccess()
                    }
                })
        //}
        } else {
            //Not all digits entered
            let alert = UIAlertController(title: "Alert", message: "Please enter the verification code", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func addDelegate(key:String, delegate:VerifyNumberViewControllerDelegate){
        self.delegates[key] = delegate
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissAndFail()
    }
    
    func dismissAndFail(){
        self.dismiss(animated: true) {
            for delegate in self.delegates.values{
                delegate.verifyViewControllerDidDismiss(success: false)
            }
        }
    }
    
    func dismissAndSuccess(){
        self.dismiss(animated: true) {
            for delegate in self.delegates.values{
                delegate.verifyViewControllerDidDismiss(success: true)
            }
        }
    }
}


protocol VerifyNumberViewControllerDelegate{
    func verifyViewControllerDidDismiss(success:Bool)
}
