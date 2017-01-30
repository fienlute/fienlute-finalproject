//
//  Goal.swift
//  GOals
//
//  Created by Fien Lute on 13-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import Foundation
import Firebase

struct Goal {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    let points: Int
    let group: String
    // let achievedBy: String
    
    init(name: String, addedByUser: String, completed: Bool, points: Int, group: String, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.points = points
        self.group = group
      //  self.achievedBy = achievedBy
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        points = snapshotValue["points"] as! Int
        group = snapshotValue["group"] as! String
        //achievedBy = snapshotValue["achievedBy"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "points": points,
            "group": group,
            //"achievedBy": achievedBy
        ]
    }
    
}
