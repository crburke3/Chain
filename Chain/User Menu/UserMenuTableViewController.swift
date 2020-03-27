//
//  UserMenuTableViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/10/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import FloatingPanel
import Kingfisher

class UserMenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var textBoxHolder: UIView!
    
    enum purpose:String {
        case FRIENDS
        case SEARCH_USERS
    }
    
    var invitation = Invite(_chainName: "", _chainPreview: "", _dateSent: "", _expirationDate: "", _sentByUsername: "", _sentByPhone: "", _sentByProfile: "", _receivedBy: "", _index: 0)
    var userArray = [ChainUser]()
    //Load with currentUser.friends
    var index: Int = 0
    var chain: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.delegate = self
        textBox.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        userArray = masterAuth.currUser.friends //Base on enum
    }

    @IBAction func sendInvites(_ sender: Any) {
        let selectedRows = self.tableView.indexPathsForSelectedRows ?? []
               var intRowsSelected = [Int]()
               for row in selectedRows {
                   intRowsSelected.append(row.row)
               }
              
               for row in intRowsSelected {
                   //userArray[row]
                   invitation.receivedBy = userArray[row].phoneNumber
                   invitation.sendInvitation { (error) in
                       if let err = error {
                           
                       } else {
                           
                       }
                   }
               }
               print("Invite Sent")
               guard let selected = self.tableView.indexPathsForSelectedRows else { return }
               for row in selected {
                   tableView.deselectRow(at: row, animated: true)
               }
               return
           
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        userArray = []
        if let text = textField.text{
            for friend in masterAuth.currUser.friends{
                if friend.username.contains(find: text){
                    userArray.append(friend)
                }
            }
        }
        tableView.reloadData()
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        cell.user = userArray[indexPath.row]
        cell.cellDidLoad()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        return cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! UserMenuCell
//        print("Selected \(cell.userName.text)")
//        cell.contentView.backgroundColor = UIColor.white
//        cell.selectedIcon.layer.backgroundColor = UIColor(displayP3Red: 15/250, green: 239/250, blue: 224/250, alpha: 0.3).cgColor
        let user = userArray[indexPath.row]
        masterNav.pushViewController(ChainProfileViewController.initFromSB(user: user), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserMenuCell
        print("Deselected \(cell.userName.text)")
        cell.selectedIcon.layer.backgroundColor = UIColor(displayP3Red: 0/250, green: 0/250, blue: 0/250, alpha: 1.0).cgColor
    }
    
}
