//
//  DataServices.swift
//  Social
//
//  Created by Daniel Bacon on 6/11/17.
//  Copyright © 2017 Daniel Bacon. All rights reserved.
//

import Foundation
import Firebase

//global
let DB_BASE = Database.database().reference()

class DataService {
    
    // Singleton: Single instance of a class that's globally accessible
    static let ds = DataService() // creates singleton
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        
        // Looks at users node and updates the child values of a given uid with the userData
        // Updates as opposed to using setValue() which overwrites data at a given node
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
}
