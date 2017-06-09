//
//  ViewController.swift
//  Social
//
//  Created by Daniel Bacon on 6/8/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: ModificationTextField!
    @IBOutlet weak var passwordText: ModificationTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("DANIEL: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("DANIEL: Successfully authenticated with Firebase")
            }
        })
    }
  
    @IBAction func signInTapped(_ sender: Any) {
        
        // Check for existence of text in both text fields
        if let email = emailText.text, let pwd = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, Error) in
                if Error == nil {
                    print("DANIEL: User authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user, Error) in
                        if Error != nil {
                            print("DANIEL: Unable to authenticate with Firebase - \(String(describing: Error))")
                        } else {
                            print("DANIEL: Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }

}

