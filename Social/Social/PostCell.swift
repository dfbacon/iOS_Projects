//
//  PostCell.swift
//  Social
//
//  Created by Daniel Bacon on 6/11/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import UIKit

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

    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likes.text = String(post.likes)
        
    }
    
}
