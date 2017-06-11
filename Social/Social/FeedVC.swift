//
//  FeedVC.swift
//  Social
//
//  Created by Daniel Bacon on 6/9/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic setup for UITableView
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Basic setup for UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Basic setup for UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // Basic setup for UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    @IBAction func signOutPressed(_ sender: Any) {

        // Remove id from keychain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)

        // Sign out of Firebase
        try! Auth.auth().signOut()

        // Call dismiss instead of performSeque in order to minimize # of active VC's
        dismiss(animated: true, completion: nil)
    }
}
