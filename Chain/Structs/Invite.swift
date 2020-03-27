//
//  Invite.swift
//  Chain
//
//  Created by Michael Rutkowski on 11/29/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Invite {
    var chainName: String = ""
    var chainPreview: String = "" //Hold URL for preview image
    var dateSent: String = ""
    var expirationDate: String = ""
    var sentByUsername: String = ""
    var sentByPhone: String = ""
    var sentByProfile: String = ""
    var receivedBy: String = ""
    var index: Int = 0
    var documentID: String = ""
    //var previewImage = ChainImage()
    
    //It would be cool to have general information of Chain appear with invitation
    
    init(_chainName:String, _chainPreview:String, _dateSent:String, _expirationDate:String, _sentByUsername:String, _sentByPhone: String, _sentByProfile:String, _receivedBy:String, _index: Int){
        self.chainName = _chainName
        self.dateSent = _dateSent
        self.expirationDate = _expirationDate
        self.sentByUsername = _sentByUsername
        self.sentByPhone = _sentByPhone
        self.sentByProfile = _sentByProfile
        self.receivedBy = _receivedBy
        self.index = _index //Keeps track of index to start off of when chain is opened from invitation
        self.chainPreview = _chainPreview
    }
    
    //init from Firestore
    init(dict: [String:Any]) {
        self.chainName = dict["chain"] as? String ?? ""
        self.dateSent = dict["dateSent"] as? String ?? ""
        self.expirationDate = dict["expirationDate"] as? String ?? ""
        self.sentByUsername = dict["sentByUsername"] as? String ?? ""
        self.sentByPhone = dict["sentByPhone"] as? String ?? ""
        self.sentByProfile = dict["sentByProfile"] as? String ?? ""
        self.receivedBy = dict["receivedBy"] as? String ?? ""
        self.index = dict["index"] as? Int ?? 0 //Keeps track of index to start off of when chain is opened from invitation
        self.chainPreview = dict["chainPreview"] as? String ?? ""
    }
    
    func toDict() -> [String:Any] {
        return ["chain":self.chainName, "dateSent":self.dateSent, "expirationDate":self.expirationDate, "sentByUsername":self.sentByUsername, "sentByPhone":self.sentByPhone, "sentByProfile":self.sentByProfile, "receivedBy":self.receivedBy, "index":self.index, "chainPreview":self.chainPreview] as [String:Any]
    }
    
    func sendInvitation(error: @escaping (String?)->()) {
        let db = Firestore.firestore()
         let invitesRef = db.collection("users").document(self.receivedBy).collection("invites")
        invitesRef.addDocument(data: self.toDict()) { (error) in
            if let err = error {
                print("Couldn't send invitation \(err)")
            } else {
                print("Invitation sent")
            }
        }
    }
    
    func removeInvitation(invitationID: String, error: @escaping (String?)->()) {
        //Need to set documentID before deleting
        self.documentID = invitationID
        let db = Firestore.firestore()
        let inviteRef = db.collection("users").document(masterAuth.currUser.phoneNumber).collection("invites")
        inviteRef.document(self.documentID).delete { (error) in
            if let err = error {print(err.localizedDescription)}
            else {
                print("Successfully removed invite from invites collection")
            }
        }
    }
    
}
