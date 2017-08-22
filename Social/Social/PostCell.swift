//
//  PostCell.swift
//  Social
//
//  Created by Daniel Bacon on 6/11/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    
    var post: Post!
    
    //add a `var user: User!` once a User model is created; can be used to change the profileImage
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? =  nil) {
        self.post = post
        self.caption.text = post.caption
        self.likes.text = String(post.likes)
        
        // Download image from Firebase Storage
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("DANIEL: Unable to download image from Firebase storage.")
                } else {
                    print("DANIEL: Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: (post.imageUrl as AnyObject) as! NSString)
                        }
                    }
                }
            })
        }

    }
    
}
