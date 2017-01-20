//
//  Group.swift
//  GOals
//
//  Created by Fien Lute on 17-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

//import Foundation
//import Firebase

//struct Group {
    // var goals: Array<Goal> = Array()
//    let name: String
//    
//    init(name: String) { //goals: Array<Any>) {
//        // self.goals = Array<Goal>()
//        self.name = name
//    }
//    
//    init(snapshot: FIRDataSnapshot) {
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        // goals = snapshotValue["goals"] as! Array
//        name = snapshotValue["name"] as! String
//    }
//    
//    func toAnyObject() -> Any {
//        return [
//            "name": name,
//        ]
//    }
//}

internal class Group {
    internal let id: String
    internal let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
