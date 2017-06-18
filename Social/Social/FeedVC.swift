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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: RoundView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage>! = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic setup for UITableView
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true // Allows for image cropping
        imagePicker.delegate = self
        
        // Put/initialize listener in viewDidLoad()
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postId: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            // Finished listening, need to reload
            self.tableView.reloadData()
        })

    }

    // Basic setup for UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Basic setup for UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Basic setup for UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        } else {
            return PostCell()
        }
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    

    // Call to remove image picker after selecting image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("DANIEL: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
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
