//
//  DetailsGroupViewController.swift
//  GOals
//
//  Created by Fien Lute on 19-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// MARK: Outlets



class DetailsGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
  
//    private var newGoalRefHandle: FIRDatabaseHandle?
//    private var updatedGoalRefHandle: FIRDatabaseHandle?
    
    // var groupRef: FIRDatabaseReference?
    var groupRef = FIRDatabase.database().reference().child("group")

    var goals = [Goal]()
    private lazy var goalRef: FIRDatabaseReference = self.groupRef.child("goals")
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var user = User(authData: (FIRAuth.auth()?.currentUser)!)
    var userCountBarButtonItem: UIBarButtonItem!
    var goal: Goal!
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        

        // Put goal into array. (works)
        self.groupRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Goal] = []
            for item in snapshot.children {
                let goal = Goal(snapshot: item as! FIRDataSnapshot)
                newItems.append(goal)
            }
            
            // to know if someone is online
            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                guard let user = user else { return }
                self.user = User(authData: user)
                let currentUserRef = self.usersRef.child(self.user.uid)
                currentUserRef.setValue(self.user.email)
                currentUserRef.onDisconnectRemoveValue()
            }
    
            self.items = newItems
           // self.tableView.reloadData()

        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableView Delegate methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let goal = items[indexPath.row]
        
//        cell.textLabel?.text = goal.name
//        cell.detailTextLabel?.text = goal.addedByUser
        
//        toggleCellCheckbox(cell, isCompleted: goal.completed)
        
        return cell
    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let goal = items[indexPath.row]
//            goal.ref?.removeValue()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 1
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        // 2
//        let goal = items[indexPath.row]
//        // 3
//        let toggledCompletion = !goal.completed
//        // 4
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        // 5
//        goal.goalref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
//    }
    
    // MARK: methods
    @IBAction func addGoal(_ sender: Any) {
        let alert = UIAlertController(title: "Goal",
                                        message: "Add a new goal",
                                              preferredStyle: .alert)
        
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            let goalField = alert.textFields![0].text
                                            let points: Int = Int(alert.textFields![1].text!)!
                                            let group = alert.textFields![2].text
                                            //let itemRef = self.groupRef.childByAutoId()
                                            
                                            let goalItem = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points, group: self.user.group)
                                        
//                                            let goalItemRef = self.itemRef.child(goalField.lowercased())
//                                            itemRef.setValue(goalItem)
//
//                                            self.groupRef = self.groupRef.child("goals")
                                            
//  self.groupRef.setValue(goalItem.toAnyObject())

                                            let goal = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points, group: self.user.group)
                                            
                                            self.items.append(goal)
                                            
// maakt nieuwe items op het level van 'goals' dus kan gebruikt worden als groepnaam ipv goals, binnen groepen --> group
                                            
                                            
//                                            let goalRef = self.groupRef.child(goalField!)
//                                            
//                                            goalRef.setValue(goalItem.toAnyObject())
                                            
                                            let itemRef = self.goalRef.childByAutoId() // 1
                                            
                                            itemRef.setValue(goalItem.toAnyObject()) // 3
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
