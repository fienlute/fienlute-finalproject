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
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    var goals = [Goal]()
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var goal: Goal!
    var user: User!
    var group: String = ""
    var name: String = ""
    var pointsInt: Int = 0
    var pointsString: String = ""
    var completedBy: String = ""
    var currentUserObject: [User] = []
//    var currentUser: FIRDatabaseReference?
    let itemRef = FIRDatabase.database().reference(withPath: "goals").childByAutoId()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            print("UID: \(self.user.uid)")
            
            let currentUser = FIRDatabase.database().reference(withPath: "Users").child(self.user.uid)
            
            
            
            currentUser.observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                
                print("GROUP: \(self.user.group)")
                
                self.group = value?["group"] as! String
                self.name = value?["email"] as! String
                
                self.pointsInt = value?["points"] as! Int
                self.pointsString = String(self.pointsInt)
                
                // Put goal into array.
                
                self.goalRef.queryOrdered(byChild: "group").queryEqual(toValue: self.group).observe(.value, with:
                    { (snapshot) in
                        
                        var newItems: [Goal] = []
                        
                        for item in snapshot.children {
                            
                            let goalItem = Goal(snapshot: item as! FIRDataSnapshot)
                            newItems.append(goalItem)
                        }
                        
                        if snapshot.exists() {
                            // print(snapshot.value)
                            print("Group: \(self.group)")
                            
                        } else {
                            print("Group: \(self.group)")
                            print("test2")
                        }
                        
                        self.items = newItems
                        self.tableView.reloadData()
                        
                })
            })
        }
        
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        title = "Goals"
 
        

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
        
//        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
//        currentUser.observeSingleEvent(of: .value, with: { snapshot in
//            
//        })
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let goalField = alert.textFields![0].text
                                        let pointsField: Int = Int(alert.textFields![1].text!)!
                                        
                                        let goalItem = Goal(name: goalField!, addedByUser: self.name, completed: false, points: pointsField, group: self.group, completedBy: self.completedBy)

                                        self.items.append(goalItem)
                                       
                                        self.itemRef.setValue(goalItem.toAnyObject())
                                        
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
        
//        let currentPointsInt = pointsInt + goal.points
//        pointsInt = currentPointsInt
//        
//        let userPointRef  = usersRef.child("points")
//        userPointRef.updateChildValues(["points":currentPointsInt])
//        
//        let completedRef = itemRef.childByAppendingPath("\(autoID)/completedBy")
//
//        completedRef.updateChildValues(["completedBy":completedBy])
//        
//        self.currentUser.child("points").setValue(pointsInt)
//        completedRef.child("completedBy").setValue(name)

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = items[indexPath.row]
            goal.ref?.removeValue()
        }
    }

}
