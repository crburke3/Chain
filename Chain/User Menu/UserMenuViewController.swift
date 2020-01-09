//
//  UserMenuViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 1/8/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

class UserMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Will be used to show users in a pop up menu (Can be used to view friends, share chain, etc.)
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet var view: UIView!
    @IBOutlet weak var holder: UIView!
    
    var userArray = [ChainUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        var clear = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        var lightOrange = UIColor(red: 1, green: 164/255, blue: 6/255, alpha: 1)
        //view.isOpaque = false
        //view.backgroundColor =  UIColor.black.withAlphaComponent(0.75)
        tableView.layer.cornerRadius = 10
        holder.layer.cornerRadius = 10
        holder.layer.backgroundColor = clear.cgColor
        holder.layer.borderColor = lightOrange.cgColor
        holder.layer.borderWidth = 3
        //holder.layer.borderColor = color as! CGColor
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        cell.userName.text = "ChristianBurke" //currentUser.friends[indexPath.index]["user"]
        cell.profilePic.image = UIImage()
        cell.profilePic.layer.borderWidth = 1
        cell.profilePic.layer.masksToBounds = false
        cell.profilePic.layer.borderColor = UIColor.black.cgColor
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height/2
        cell.profilePic.clipsToBounds = true
        cell.cellDidLoad()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //currentUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! UserMenuCell
        return cell.frame.height
    }

    

}
