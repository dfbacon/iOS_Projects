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

class FeedVC: UIViewController {

    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
