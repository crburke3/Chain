//
//  InvitesViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/26/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class InvitesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore()
    var inviteArray = [Invite]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteArray.removeAll()
        let invitesRef = db.collection("users").document(currentUser.phoneNumber).collection("invites")
        let nibCell = UINib(nibName: "InviteTableViewCell", bundle: nil)
               tableView.register(nibCell, forCellReuseIdentifier: "InviteTableViewCell")
               tableView.dataSource = self
               tableView.delegate = self
               self.tableView.reloadData()
        //Paginate by date sent
        db.collection("users").document(currentUser.phoneNumber).collection("invites").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let invite = Invite(dict: document.data() as [String : Any])
                        self.inviteArray.append(invite)
                        self.tableView.reloadData()
                    }
                }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return inviteArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteTableViewCell", for: indexPath) as! InviteTableViewCell
            //cell.username.text = "Christian"
            //let url = URL(string: currentUser.profile ?? "")
            let url = URL(string: inviteArray[indexPath.row].chainPreview ?? "")
            cell.chainPreview.kf.setImage(with: url)
            let urlForProfile = URL(string: inviteArray[indexPath.row].sentByProfile ?? "")
            cell.chainTitle.text = inviteArray[indexPath.row].chainName
            cell.sendersProfilePic.kf.setImage(with: urlForProfile)
                //= inviteArray[indexPath.row].sentByProfile
            cell.message.text = "\(inviteArray[indexPath.row].sentByUsername) invited you to view a chain!"
            //Add time count down
            return cell
        }
    

}
