//
//  SignUpViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    let db = Firestore.firestore()
    let auth = ChainAuth()
    /*
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
    
    
    */
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var name: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextStep(_ sender: Any) {
        
        if phoneNumber.text?.count != 0 && name.text?.count != 0 && username.text?.count != 0 {
            //Set label in next view
            //Push next view
            db.collection("users").whereField("phone", isEqualTo: formatPhone())
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
            
                    }
                    print(self.formatPhone())
                    if querySnapshot?.count == 0 {
                        let phoneNumber = self.formatPhone()
                        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                          if let error = error {
                            print(error)
                            return
                          } else {
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID") //Save verification code
                            }
                          // Sign in using the verificationID and the code sent to the user
                          // ...
                        }
                       /* self.auth.sendVerificationCode(phoneNumber: self.formatPhone(), error: { error in
                             if let error = error {
                                 print("\(error) -> Unable to send verification code")
                             } else {
                                 
                             }
                         }) //Original number */
                        let verifyVC = VerifyNumberViewController()
                        verifyVC.phone = self.formatPhone()
                        masterNav.pushViewController(verifyVC, animated: true) //Push verify page
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "Number has already been taken", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } //Close query
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please fill out all fields", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func formatPhone() -> String {
        return "+1\(phoneNumber?.text ?? "")" //Will vary by country
    }
}
