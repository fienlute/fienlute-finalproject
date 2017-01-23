//
//  User.swift
//  GOals
//
//  Created by Fien Lute on 13-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    var group: String
    let points: Int
    let key: String
    let ref: FIRDatabaseReference?
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
        key = ""
        ref = nil
        group = ""
        points = 0
    }
    
    init(uid: String, email: String, group: String,points: Int, key: String = "") {
        self.uid = uid
        self.email = email
        self.group = group
        self.points = points
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value! as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        email = snapshotValue["email"] as! String
        group = snapshotValue["group"] as! String
        points = snapshotValue["points"] as! Int
        ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "email": email,
        ]
    }
}




//let uid: String
//let email: String
//let password: String
//let group: String
//let username: String
//let points: Int
//
//init(uid: String, email: String, password: String, group: String, username: String, points: Int) {
//    self.uid = uid
//    self.email = email
//    self.password = password
//    self.group = group
//    self.username = username
//    self.points = points
//}
