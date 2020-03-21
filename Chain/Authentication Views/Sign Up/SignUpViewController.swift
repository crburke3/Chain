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
import CTKFlagPhoneNumber

class SignUpViewController: UIViewController, VerifyNumberViewControllerDelegate {
    
    @IBOutlet var emailField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var phoneNumber: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var name: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var username: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet var allOtherObjects: [Any]!
    
    let db = Firestore.firestore()
    let loader = BeautifulLoadScreen(lottieAnimation: .ChainBreak)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlpha(alpha: 0.0)
        view.addSubview(loader)
        loader.isHidden = true
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
        if true{
            return true
        }else{
            let alert = UIAlertController(title: "Alert", message: "Number has already been taken", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    @IBAction func back(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    
    @IBAction func nextStep(_ sender: Any) {
        if !goodFields(){return}
        loader.fadeIn()
        let phone =  phoneNumber.getFormattedPhoneNumber()!
        let verifyVC = VerifyNumberViewController(phoneNumber: phone)
        verifyVC.addDelegate(key: "SignUpViewController", delegate: self)
        masterNav.present(verifyVC, animated: true, completion: nil)
    }
    
    func verifyViewControllerDidDismiss(success: Bool) {
        if success{
            saveString(str: password.text!, location: .password)
            saveString(str: emailField.text!, location: .email)
            saveString(str: phoneNumber.getFormattedPhoneNumber()!, location: .phoneNumber)
            let phone =  phoneNumber.getFormattedPhoneNumber()!
            let db = Firestore.firestore()
            let emptyStrArr:[String] = []
            let emptyDict:[[String:Any]] = [[:]]
            let userData:[String:Any] = ["bio": "",
                            "blocked": emptyStrArr,
                            "invites": emptyDict,
                            "phone": phone,
                            "profilePhoto": "",
                            "topPhotos": emptyStrArr,
                            "password": password.text!,
                            "friends": emptyDict,
                            "email" : emailField.text!]
        
            let userFeed = ["posts": emptyDict]
            db.collection("users").document(phone).setData(userData) //What if this fails?
            db.collection("userFeeds").document(phone).setData(userFeed)
            Auth.auth().createUser(withEmail: emailField.text!, password: password.text!) { (result, err) in
                self.loader.fadeOut()
                if result == nil || err != nil{
                    self.showPopUp(_title: "Error Creating Your Account", _message: "check your connection and try again")
                    print("Create account error: \(err?.localizedDescription)"); return
                }
                let additionalInfoVC = AdditionalInfoViewController()
                additionalInfoVC.phone = phone
                masterNav.pushViewController(additionalInfoVC, animated: true)
            }
        }else{
            loader.fadeOut()
            print("User canceled the phoen auth")
        }
    }
    

    func formatPhone() -> String {
        return "+1\(phoneNumber?.text ?? "")" //Will vary by country
    }
    
    func checkPassword() -> Bool {
        return true
    }
}
