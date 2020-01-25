//
//  FriendsViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/24/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleOfVC: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: "FriendTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "FriendTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        //Get initial 10 friends
    }
    @IBAction func goBack(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        cell.username.text = "Christian"
        let url = URL(string: currentUser.profile ?? "")
        /*cell.profilePic.kf.setImage(with: url)
        cell.profilePic.layer.borderWidth = 1
        cell.profilePic.layer.masksToBounds = false
        cell.profilePic.layer.borderColor = UIColor.black.cgColor
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
        cell.profilePic.clipsToBounds = true
*/
        /*
        let dict = usersArray[indexPath.row]
        
        cell.lblFirstName.text = dict["first_name"]
        cell.lblLastName.text = dict["last_name"]
        */
        return cell
    }
}
