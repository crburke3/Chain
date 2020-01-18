//
//  SignInViewController.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import SkyFloatingLabelTextField

class SignInViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    
    let db = Firestore.firestore()
    let auth = ChainAuth()
    /*
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField?
    @IBOutlet weak var verificationCode: SkyFloatingLabelTextField?
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //
    @IBAction func forgotPassword(_ sender: Any) {
        //Push Phone-Auth view
        //Once complete prompt and store new password
    }
    @IBAction func signIn(_ sender: Any) {
        var storedPassword: String = ""
        db.collection("users").whereField("phone", isEqualTo: formatPhone())
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        storedPassword = document.get("password") as! String
                    }
                }
                if querySnapshot?.count == 0 { //No results for phone
                    print(querySnapshot?.count)
                    let alert = UIAlertController(title: "Alert", message: "No results for phone number", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                if self.password.text?.count == 0 {
                    let alert = UIAlertController(title: "Alert", message: "Please enter a password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                if storedPassword == self.password.text {
                    let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ChainViewController") as! ChainViewController
                    mainVC.mainChain = PostChain(chainID: "firstChain", load: true)
                    masterNav.pushViewController(mainVC, animated: true) //Push MainChain
                } else { //Incorrect
                    let alert = UIAlertController(title: "Ok", message: "Incorrect Password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        masterNav.pushViewController(SignUpViewController(), animated: true) //Load Sign Up View
    }
    
    //
    func formatPhone() -> String {
        return "+1\(phoneNumber?.text ?? "")" //Will vary by country
    }
    /*
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
    */
}
