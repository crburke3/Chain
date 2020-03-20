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
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else{error("No saved Code"); return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode) //Load object
        //Sign In
        Auth.auth().signIn(with: credential) { (authResult, err1) in
            if let error1 = err1 {
                print(error1.localizedDescription) //Failed to sign in
                error(error1.localizedDescription)
                return
            }else{
                print("Authenticated in successfully")//Signed In
                error(nil)
            }
        }
    }
    
    func verifyCodeAndLogin(verificationCode: String, phone: String, error: @escaping (String?)->()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "" //Retrieve ID
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode) //Load object
        //Sign In
        Auth.auth().signIn(with: credential) { (authResult, err1) in
          if let error1 = err1 {
               print(error1.localizedDescription) //Failed to sign in
               return
          } else {
                print("Signed in successfully")//Signed In
                error(nil)
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
    
    static func emailFromPhone(phone:String, email: @escaping (String?)->()){
        let ref = masterFire.db.collection("users").document(phone)
        ref.getDocument { (snap, err) in
            guard let _email = snap?.data()?["email"] as? String else{email(nil); return}
            email(_email)
        }
    }
    
    static func initFrom(phone:String, password:String, chainAuth: @escaping(ChainAuth?)->()){
        let retAuth = ChainAuth()
        ChainAuth.emailFromPhone(phone: phone) { (email) in
            if email == nil{chainAuth(nil); return}
            Auth.auth().signIn(withEmail: email!, password: password) { (result, error) in
                if result == nil || error != nil{
                    print("Login Error \(error?.localizedDescription)")
                    chainAuth(nil); return
                }
                ChainUser.initFromFirestore(with: phone) { (user) in
                    if user != nil{
                        retAuth.currUser = user!
                        chainAuth(retAuth)
                    }
                }
            }
        }
    }
}
