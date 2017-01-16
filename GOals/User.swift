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
        
        init(authData: FIRUser) {
            uid = authData.uid
            email = authData.email!
        }
        
        init(uid: String, email: String) {
            self.uid = uid
            self.email = email
    }
}
