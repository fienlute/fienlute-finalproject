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
    //var goalRef: FIRDatabaseReference!
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    // let goalRef = FIRDatabase.database().reference().child("goals")


    var goals = [Goal]()
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var goal: Goal!
    var user: User!
    
    var currentUserObject: [User] = []

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        title = "goals"

        
        
        print("UID:\(FIRAuth.auth()!.currentUser?.uid)")
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()?.currentUser)!.uid)
        
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            var group: String = ""
            var name: String = ""
            // var points: String = ""
            
            let value = snapshot.value as? NSDictionary
            group = value?["group"] as! String
            name = value?["email"] as! String
            // points = value?["points"] as! String
            
            // print("Group: \(group)")
            
        // Put goal into array.

            self.goalRef.queryOrdered(byChild: "group").queryEqual(toValue: group).observe(.value, with:
                { (snapshot) in
    //            self.goalRef.queryOrdered(byChild: "group").observe(.value, with: { snapshot in
            
                    var newItems: [Goal] = []
                    
                    for item in snapshot.children {
                    
                        let goalItem = Goal(snapshot: item as! FIRDataSnapshot)
                        newItems.append(goalItem)
                    }
                    
                    if snapshot.exists() {
                        print(snapshot.value)
                        print("Group: \(group)")
                    
                    } else {
                        print("Group: \(group)")
                        print("test2")
                    }
    //
                self.items = newItems
                self.tableView.reloadData()
                
            })
            

        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    // MARK :Actions

    @IBAction func addGoalDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Goal",
                                      message: "Add a new goal",
                                      preferredStyle: .alert)
        
        var group: String = ""
        var user: String = ""
        
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            group = value?["group"] as! String
            user = value?["email"] as! String
            
            print("Group: \(group)")
            
        })
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let goalField = alert.textFields![0].text
                                        let points: Int = Int(alert.textFields![1].text!)!
                                        
                                        let goalItem = Goal(name: goalField!, addedByUser: user, completed: false, points: points, group: group)

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
