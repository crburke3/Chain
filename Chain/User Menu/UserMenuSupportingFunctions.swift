//
//  UserMenuSupportingFunctions.swift
//  Chain
//
//  Created by Michael Rutkowski on 3/19/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UserMenuTableViewController {
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        textBoxHolder.layer.cornerRadius = 12
        self.tableView.reloadData()
    }
    
    @objc func showDetail(_ button:UIButton) -> Int{
        let selectedRows = self.tableView.indexPathsForSelectedRows ?? []
        var intRowsSelected = [Int]()
        for row in selectedRows {intRowsSelected.append(row.row)}
        for row in intRowsSelected {
            invitation.receivedBy = userArray[row].phoneNumber
            invitation.sendInvitation { (error) in
                if let err = error {} else {}
            }
        }
        print("Invite Sent")
        guard let selected = self.tableView.indexPathsForSelectedRows else { return 0 }
        for row in selected {tableView.deselectRow(at: row, animated: true)}
        return 1
    }
    
    func searchUser() {
        //Matching or contains query
        userArray.removeAll()
        if purposeOfUse == .SEARCH_USERS {
            let db = Firestore.firestore()
            db.collection("users").whereField("username", isEqualTo: textBox.text).getDocuments() { (querySnapshot, error) in
                if let error = error { print(error) } else {
                    for document in querySnapshot!.documents {
                        //Push results to table view
                        self.userArray.append(ChainUser(dict: document.data()))
                    }
                    self.tableView.reloadData()
                }
            }
        } else {
            //Search through Friends
        }
    }

}
