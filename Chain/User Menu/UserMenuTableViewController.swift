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

class UserMenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var textBoxHolder: UIView!
    
    var invitation = Invite(_chainName: "", _chainPreview: "", _dateSent: "", _expirationDate: "", _sentByUsername: "", _sentByPhone: "", _sentByProfile: "", _receivedBy: "", _index: 0)
    var userArray = [ChainUser]()
    var filteredUserArray = [ChainUser]() //
    //Load with currentUser.friends
    var index: Int = 0
    var chain: String = ""
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        textBoxHolder.layer.cornerRadius = 12
        userArray = currentUser.friends
        //self.view.bringSubviewToFront(self.sendButton)
        
        
    }
    //
   
    //
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
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        cell.userName.text = userArray[indexPath.row].username //currentUser.friends[indexPath.index]["user"]
        let url = URL(string: userArray[indexPath.row].profile)
        cell.profilePic.kf.setImage(with: url)
        cell.phone = userArray[indexPath.row].phoneNumber
        //cell.profilePic.image = UIImage()
        cell.profilePic.layer.borderWidth = 1
        cell.profilePic.layer.masksToBounds = false
        cell.profilePic.layer.borderColor = UIColor.black.cgColor
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
        cell.profilePic.clipsToBounds = true
        
        cell.selectedIcon.layer.borderWidth = 0.5
        cell.selectedIcon.layer.masksToBounds = false
        cell.selectedIcon.layer.borderColor = UIColor.lightGray.cgColor
        cell.selectedIcon.layer.cornerRadius = cell.selectedIcon.frame.height/2
        cell.selectedIcon.clipsToBounds = true
        cell.cellDidLoad()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        return cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Be able to select multiple
        //let cell = tableView.cellForRow(at: indexPath) as! UserMenuCell
        let cell = tableView.cellForRow(at: indexPath) as! UserMenuCell
        print("Selected \(cell.userName.text)")
        //cell.contentView.backgroundColor = UIColor(displayP3Red: 15/250, green: 239/250, blue: 224/250, alpha: 0.3)
        cell.contentView.backgroundColor = UIColor.white
        cell.selectedIcon.layer.backgroundColor = UIColor(displayP3Red: 15/250, green: 239/250, blue: 224/250, alpha: 0.3).cgColor
        /*
        let profile = ProfileViewController()
        profile.user = ChainUser(_username: "mikey", _phoneNumber: "123", _name: "Rut")
        masterNav.pushViewController(profile, animated: true)
    */
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserMenuCell
        print("Deselected \(cell.userName.text)")
        //cell.contentView.backgroundColor = UIColor.white
        cell.selectedIcon.layer.backgroundColor = UIColor(displayP3Red: 0/250, green: 0/250, blue: 0/250, alpha: 1.0).cgColor
    }
    
    @objc func showDetail(_ button:UIButton) -> Int{
        //Gather array of users
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
        guard let selected = self.tableView.indexPathsForSelectedRows else { return 0 }
        for row in selected {
            tableView.deselectRow(at: row, animated: true)
        }
        return 1
    }
    

}
