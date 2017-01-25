//
//  RankingViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RankingViewController: UIViewController { //UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet weak var tableView: UITableView!
//    
    let usersRef = FIRDatabase.database().reference(withPath: "Users")
    var user: User!
    var items: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background mountains
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        title = "ranking"
        
        var group: String = ""
        var email: String = ""
        var points: String = ""
        
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            email = value?["email"] as! String
            points = value?["points"] as! String
            
            // print("Group: \(group)")
            
        })

//        // Puts users of group into array
//        self.usersRef.queryOrdered(byChild: "points").observe(.value, with: { snapshot in
//            
//            var newItems: [User] = []
//            var group = String()
//            for item in snapshot.children {
//                let user = User(snapshot: item as! FIRDataSnapshot)
//                newItems.append(user)
//                
//                // for group in user.group {
//               //     if group == (currentUser?.group)! {
//                //        newItems.append(items)
//               //     }
//               // }
//            }
//            
//            self.items = newItems
//            self.tableView.reloadData()
//            
//        })
//        
    }
//
//
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
