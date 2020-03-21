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
import CTKFlagPhoneNumber

class SignInViewController: UIViewController {
    
    
    @IBOutlet var allOtherObjects: [Any]!
    
    @IBOutlet var phoneNumber: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    
    let db = Firestore.firestore()
    let auth = ChainAuth()
    let loader = BeautifulLoadScreen(lottieAnimation: .UglyChain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.textColor = .white
        setAlpha(alpha: 0.0)
        view.addSubview(loader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
            self.setAlpha(alpha: 1.0)
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
            self.setAlpha(alpha: 0.0)
        }, completion: nil)
    }
    
    func setAlpha(alpha:CGFloat){
        for object in allOtherObjects{
            switch object{
            case is UIButton:
                (object as! UIButton).alpha = alpha
            case is UILabel:
                (object as! UILabel).alpha = alpha
            case is SkyFloatingLabelTextField:
                (object as! SkyFloatingLabelTextField).alpha = alpha
            case is CTKFlagPhoneNumberTextField:
                (object as! SkyFloatingLabelTextField).alpha = alpha
            default:
                return
            }
        }
    }
    
    func goodFields()->Bool{
        return true
    }
    
    @IBAction func signIn(_ sender: Any) {
        if !goodFields(){return}
        loader.fadeIn()
        let phone = phoneNumber.getFormattedPhoneNumber()!
        let pass = password.text!
        saveString(str: phone, location: .phoneNumber)
        saveString(str: pass, location: .password)
        ChainAuth.initFrom(phone: phone, password: pass) { (auth) in
            self.loader.fadeOut()
            if auth != nil{
                masterAuth = auth!
                let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
                masterNav.pushViewController(mainVC, animated: true)
            }else{
                self.showPopUp(_title: "Error Logging In", _message: "please try again")
            }
        }
        
//        var storedPassword: String = ""
//        db.collection("users").whereField("phone", isEqualTo: formatPhone())
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                        storedPassword = document.get("password") as! String
//                    }
//                }
//                if querySnapshot?.count == 0 { //No results for phone
//                    print(querySnapshot?.count)
//                    let alert = UIAlertController(title: "Alert", message: "No results for phone number", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                if self.password.text?.count == 0 {
//                    let alert = UIAlertController(title: "Alert", message: "Please enter a password", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                if storedPassword == self.password.text {
//                    masterFire.getCurrentUsersData(phone: self.formatPhone() ?? "") { (error) in
//                        if let error = error {
//
//                        } else {
//                            //Why is this not called?
//                        }
//                    }
//
//                } else { //Incorrect
//                    let alert = UIAlertController(title: "Ok", message: "Incorrect Password", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        masterNav.pushViewController(SignUpViewController(), animated: true) //Load Sign Up View
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        if phoneNumber.text?.count == 0 {
            let alert = UIAlertController(title: "Reset Password", message: "Please enter your number before proceeding", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let verifyVC = VerifyNumberViewController(phoneNumber: formatPhone())
            masterNav.pushViewController(verifyVC, animated: true)
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    

    
    //
    func formatPhone() -> String {
        return phoneNumber.getFormattedPhoneNumber() ?? ""
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
