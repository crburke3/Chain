//
//  SearchUsersViewController.swift
//  Chain
//
//  Created by Michael Rutkowski on 3/17/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit

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
    }
    
}
