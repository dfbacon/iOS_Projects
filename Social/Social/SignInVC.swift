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
    }
    
    override func viewDidAppear(_ animated: Bool) {

        // Segue to FeedVC
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }

    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("DANIEL: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("DANIEL: Successfully authenticated with Firebase")
                
                // uid comes from the user in the completion method of the sign in handler
                // KEY_UID saved in Constants.swift
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
  
    @IBAction func signInTapped(_ sender: Any) {
        
        // Check for existence of text in both text fields
        if let email = emailText.text, let pwd = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, Error) in
                if Error == nil {
                    print("DANIEL: User authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user, Error) in
                        if Error != nil {
                            print("DANIEL: Unable to authenticate with Firebase - \(String(describing: Error))")
                        } else {
                            print("DANIEL: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }

    func completeSignIn(id: String, userData: [String: String]) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("DANIEL: Data saved to keychain")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

