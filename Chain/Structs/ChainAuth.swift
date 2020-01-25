//
//  ChainAuth.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
//import FirebaseDatabase
import Firebase

//This class will handle functions related to the user logging in and creating an account.
//It will also store the current user
class ChainAuth {
    
    var currUser:ChainUser!
    
    func sendVerificationCode(phoneNumber: String, error: @escaping (String?)->()) {
        Auth.auth().languageCode = "en"; //Set language to English
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
           if let error = error {
             print(error.localizedDescription)
             print("Not working")
             return
           }
            print("Verification Code: \(verificationID ?? "None")")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID") //Save verification ID
             
         }
        
         let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
        
    }
    //Have one successful loging/verify before creating user doc
    
    func verifyCode(verificationCode: String, error: @escaping (String?)->()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode) //Load object
        //Sign In
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
          if let error = error {
               print(error.localizedDescription) //Failed to sign in
               return
          } else {
                print("Signed in successfully")//Signed In
                self.signUpUser(create: ChainUser(_username: "mbr", _phoneNumber: "+19802550653", _name: "Michael Rutkowksi")) { (error) in
                        if let err = error {
                            print(err)
                            return
                        } else {
                           //self.currUser = create //Set current user object to sign up user //Signed user up
                        }
                  //auth.signUpUser(create: user))
                }
            }
        }
    }
    
    func logInUserAfterVerification(verificationCode: String, phone: String, password: String, error: @escaping (String?)->()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode) //Load object
        //Sign In
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
          if let error = error {
               print(error.localizedDescription) //Failed to sign in
               return
          } else {
                print("Signed in successfully")//Signed In
                //Segue to additional info view
                //Create users, userFeeds docs
                let db = Firestore.firestore()
            let userData = ["bio": "","blocked": [""], "invites": [[:]], "phone": phone, "profilePhoto": "", "topPhotos": [""], "password": password, "friends": [[:]]] as [String:Any]
                let userFeed = ["posts": [[:]]]
                db.collection("users").document(phone).setData(userData) //What if this fails?
                db.collection("userFeeds").document(phone).setData(userFeed)
                let additionalInfoVC = AdditionalInfoViewController()
                additionalInfoVC.phone = phone
                masterNav.pushViewController(additionalInfoVC, animated: true)
            }
        }
    }
    
    func signUpUser(create: ChainUser, error: @escaping (String?)->()) {
           let db = Firestore.firestore()
        db.collection("users").document(create.phoneNumber).setData(create.toDict()) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
    }
    
    func checkUsernameAvailability() {
        
    }
    
    func signInWithPassword(phone: String, password: String) {
        
    }
    
    func continueToChangePassword(verificationCode: String, phone: String, error: @escaping (String?)->()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode) //Load object
        //Sign In
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
          if let error = error {
               print(error.localizedDescription) //Failed to sign in
               return
          } else {
                print("Signed in successfully, now lets change your password")//Signed In
                //Segue to change password VC
                let changePasswordVC = ChangePasswordViewController()
                masterFire.getCurrentUsersData(phone: phone) { (error) in
                    //Get users data
                }
                masterNav.pushViewController(changePasswordVC, animated: true)
            }
        }
    }
    
    func changePassword(password: String, phone: String, error: @escaping (String?)->()) {
        let db = Firestore.firestore()
        let washingtonRef = db.collection("users").document(password)
        washingtonRef.updateData([
            "password": password
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                masterFire.getCurrentUsersData(phone: phone) { (error) in
                    //
                }
            }
        }
    }
}
