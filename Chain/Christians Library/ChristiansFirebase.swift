//
//  ChristiansFirebase.swift
//  BurkesBot
//
//  Created by Christian Burke on 4/15/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChristiansFirebase{
    class CBFirestore{
        let db = Firestore.firestore()
        
        func getDataFromDocument(_collection:String, _documentID:String, dictionary: @escaping (Dictionary<String, Any>?)->()){
            let doc = db.collection(_collection).document(_documentID)
            doc.getDocument { (snapshot, err) in
                if let error = err{
                    print("Error getting documents: \(error)");
                    dictionary(nil)
                }else{
                    if let retDict = snapshot!.data(){
                        dictionary(retDict)
                    }else{
                        dictionary(nil)
                    }
                }
            }
        }
        
        func setDocumentData(_collection:String, _documentID:String, uploadDict:(Dictionary<String, Any>), completion: @escaping (Bool, String)->()){
            let ref = db.collection(_collection).document(_documentID)
            ref.setData(uploadDict, merge: true) { (err) in
                if let error = err{
                    completion(false, error.localizedDescription)
                }else{
                    completion(true, "")
                }
            }
        }
    }
    
    class CBFireAuth{
        let auth = Auth.auth()
        
        func signUpUser(_email:String, _password:String, completion: @escaping (Bool, String)->()){
            auth.createUser(withEmail: _email, password: _password) { authResult, error in
                if let err = error{
                    print("Error Authenticating: \(err)");
                    completion(false, err.localizedDescription)
                }else{
                    completion(true, "")
                }
            }
        }
        
        func setUsername(_username:String, completion: @escaping (Bool, String)->()){
            if let user = auth.currentUser{
                let request = user.createProfileChangeRequest()
                request.displayName = _username
                request.commitChanges { (err) in
                    if let error = err{
                        completion(false, error.localizedDescription)
                    }else{
                        completion(true, "")
                    }
                }
            }else{
                completion(false, "No Current User logged in")
            }
        }
        
        func logout(completion: @escaping (Bool, String)->()){
            do{
                try auth.signOut()
                completion(true, "")
            }catch{
                completion(false, error.localizedDescription)
            }
        }
        
        func loginUser(_email:String, _password:String, completion: @escaping (Bool, String)->()){
            auth.signIn(withEmail: _email, password: _password) { (authResult, error) in
                if let err = error{
                    print("Error Loging in: \(err)");
                    completion(false, err.localizedDescription)
                }else{
                    completion(true, "")
                }
            }
        }
        
    }
}
