//
//  ViewController.swift
//  Social
//
//  Created by Daniel Bacon on 6/8/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: ModificationTextField!
    @IBOutlet weak var passwordText: ModificationTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
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
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, Error) in
                if Error == nil {
                    print("DANIEL: User authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user, Error) in
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

