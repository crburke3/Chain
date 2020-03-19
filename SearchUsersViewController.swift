//
//  SearchUsersViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 3/17/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SearchUsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }
    @IBAction func searchChanged(_ sender: Any) {
        searchUser()
    }
    
    func searchUser() {
        //Matching or contains query
        let db = Firestore.firestore()
        
        db.collection("users").whereField("username", isEqualTo: searchText.text).getDocuments() { (querySnapshot, error) in
            if let error = error { print(error) } else {
                for document in querySnapshot!.documents {
                    //Push results to table view
                }
            }
        }
    }
    
}
