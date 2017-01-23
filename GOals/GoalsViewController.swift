//
//  GoalsViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var senderDisplayName: String?

    private lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference().child("goals")
    private var refHandle: FIRDatabaseHandle?
    
    var goalRef: FIRDatabaseReference!
    
//    var ref = FIRDatabase.database().reference().child(withPath: "group")
    
    var goals = [Goal]()
//    private lazy var goalRef: FIRDatabaseReference = self.ref.child("goals")
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var user = User(authData: (FIRAuth.auth()?.currentUser)!)
    var groupItems: [Group] = []
    var userCountBarButtonItem: UIBarButtonItem!
    var goal: Goal!
    let usersRef = FIRDatabase.database().reference(withPath: "online")

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalRef =  FIRDatabase.database().reference(withPath: "goals")
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)

        title = "goals"
        
        // Put goal into array. (works)
        self.ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
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
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK :Actions
//    @IBAction func createGroup(_ sender: Any) {
//        if let name = newGroupTextField?.text { // 1
//            let newref = ref.childByAutoId() // 2
//            let groupItem = [ // 3
//                "name": name
//            ]
//            newref.setValue(groupItem) // 4
//        }
//    }
    
    
    @IBAction func addGoalDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Goal",
                                      message: "Add a new goal",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let goalField = alert.textFields![0].text
                                        let points: Int = Int(alert.textFields![1].text!)!
                                        let group = alert.textFields![2].text
                                        //let itemRef = self.ref.childByAutoId()
                                        
                                        let goalItem = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points, group: self.user.group)
                                        
                                        //                                            let goalItemRef = self.itemRef.child(goalField.lowercased())
                                        //                                            itemRef.setValue(goalItem)
                                        //
                                        //                                            self.ref = self.ref.child("goals")
                                        
                                        //  self.ref.setValue(goalItem.toAnyObject())
                                        
                                        let goal = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points, group: self.user.group)
                                        
                                        self.items.append(goal)
                                        
                                        // maakt nieuwe items op het level van 'goals' dus kan gebruikt worden als groepnaam ipv goals, binnen groepen --> group
                                        
                                        
                                        let goalRef = self.ref.child(goalField!)
                                
                                        goalRef.setValue(goalItem.toAnyObject())
                                        
                                        let itemRef = goalRef.childByAutoId() // 1
                                        
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
    
    @IBAction func LogoutDidTouch(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = items[indexPath.row]
            goal.ref?.removeValue()
        }
    }

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
//        goal.goalRef?.updateChildValues([
//            "completed": toggledCompletion
//            ])
//    }

    // MARK: UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == Section.currentGroupsSection.rawValue {
//            let group = groups[(indexPath as NSIndexPath).row]
//            self.performSegue(withIdentifier: "showGoals", sender: group)
//        }
//    }
    
    // MARK: Firebase related methods
//    private func observeGroups() {
//        // Use the observe method to listen for new
//        // channels being written to the Firebase DB
//        refHandle = ref.observe(.childAdded, with: { (snapshot) -> Void in // 1
//            let groupData = snapshot.value as! Dictionary<String, AnyObject> // 2
//            let id = snapshot.key
//            if let name = groupData["name"] as! String!, name.characters.count > 0 { // 3
//                self.goals.append(Group(id: id, name: name))
//                self.tableView.reloadData()
//            } else {
//                print("Error! Could not decode channel data")
//            }
//        })
//    }

}
