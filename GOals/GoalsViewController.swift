//
//  GoalsViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var senderDisplayName: String?
    // var goalRef: FIRDatabaseReference!
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    var goals = [Goal]()
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var goal: Goal!
    var currentGroup: String = ""
    var currentUid: String = ""
    var currentPoints: String = ""
    var currentEmail: String = ""
    
    let currentUsersRef = FIRDatabase.database().reference(withPath: "Users")
    //let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
    var user: User!
    
    var currentUserObject: [User] = []
    // var groupRef = FIRDatabase.database().reference(withPath: "goals").child(goal.group)

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)

        title = "goals"
        
        var group: String = ""

        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            group = value?["group"] as! String

            // print("Group: \(group)")
            
        })

        // Put goal into array.
        
        var currentGroupa: String = group

        //        goalRef.queryOrdered(byChild: "group").queryEqual(toValue: "hoi").observeSingleEvent(of: .value, with:
//            { (snapshot:FIRDataSnapshot) in
            self.goalRef.queryOrdered(byChild: "group").observe(.value, with: { snapshot in
                
                var newItems: [Goal] = []
                
                for item in snapshot.children {
                    let goalItem = Goal(snapshot: item as! FIRDataSnapshot)
                    let goal = Goal(snapshot: item as! FIRDataSnapshot)
                    newItems.append(goalItem)
                }
                
                if snapshot.exists() {
                    print(snapshot.value)
                
                } else {
                    print("Group: \(group)")
                    print("test2")
                }
            
                
//
                

//            // self.goalRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
//
//          //   to know if someone is online
//            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//                guard let user = user else { return }
//                self.user = User(authData: user)
//                let currentUserRef = self.usersRef.child(self.user.uid)
//                currentUserRef.setValue(self.user.email)
//                currentUserRef.onDisconnectRemoveValue()
//            }
//            
            self.items = newItems
            self.tableView.reloadData()
            
        })


    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        retrieveUserData{(uid, email, group, points) in
            self.currentUid = uid
            self.currentEmail = email
            self.currentGroup = group
            self.currentPoints = String(points)

        }
        
    }
    
    // MARK :Actions

    @IBAction func addGoalDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Goal",
                                      message: "Add a new goal",
                                      preferredStyle: .alert)
        
        var group: String = ""
        
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            group = value?["group"] as! String

            print("Group: \(group)")
            
        })
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let goalField = alert.textFields![0].text
                                        let points: Int = Int(alert.textFields![1].text!)!
                                        
                                        let goalItem = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points, group: group)

                                        self.items.append(goalItem)
                                        
                                        let itemRef = self.goalRef.childByAutoId() // 1
                                        
                                        itemRef.setValue(goalItem.toAnyObject())
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textGoal in
            textGoal.placeholder = "Enter a new goal"
        }
        
        alert.addTextField { textPoints in
            textPoints.placeholder = "How many points is this worth?"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }

    @IBAction func LogoutDidTouch(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            // self.performSegue(withIdentifier: "toLogin", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    func retrieveUserData(completionBlock : @escaping ((_ uid : String, _ email : String, _ group : String, _ points : Int)->Void)) {
        goalRef.child(FIRAuth.auth()!.currentUser!.uid).observe(.value , with: {snapshot in
            
            if let userDict =  snapshot.value as? [String:AnyObject]  {
                
                completionBlock(userDict["uid"] as! String, userDict["email"] as! String, userDict["group"] as! String, userDict["points"] as! Int)
            }
        })
        
    }

    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalsCell
        let goal = items[indexPath.row]
        
        cell.goalLabel.text = goal.name
        cell.addedByLabel.text = goal.addedByUser
        cell.pointsLabel.text = String(goal.points)

        toggleCellCheckbox(cell, isCompleted: goal.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let goal = items[indexPath.row]

        let toggledCompletion = !goal.completed

        toggleCellCheckbox(cell, isCompleted: toggledCompletion)

        goal.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = items[indexPath.row]
            goal.ref?.removeValue()
        }
    }

}
