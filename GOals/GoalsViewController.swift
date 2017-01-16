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
    
    @IBOutlet weak var tableView: UITableView!
    
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [Goal] = []
    let ref = FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set background mountains
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        // name first item tab bar
        tabBarItem = UITabBarItem(title: "Goals", image: UIImage(named: "avatar-icon"), tag: 0)
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Goal] = []
            
            for item in snapshot.children {
                let goal = Goal(snapshot: item as! FIRDataSnapshot)
                newItems.append(goal)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalsCell
        let goal = items[indexPath.row]

        cell.labelGoal?.text = goal.name
        cell.labelUser?.text = goal.addedByUser
        
        
        toggleCellCheckbox(cell, isCompleted: goal.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = items[indexPath.row]
            goal.ref?.removeValue()
        }
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
    
    // MARK: Add Item

    @IBAction func addButtonDidTouch(_ sender: Any) {
    let alert = UIAlertController(title: "Goal",
                                      message: "Add a new goal",
                                      preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save",
                                style: .default) { _ in
                                    guard let textField = alert.textFields?.first,
                                        let text = textField.text else { return }
                                    
                                    let goal = Goal(name: text,
                                                            addedByUser: self.user.email,
                                            completed: false)

                                    let goalRef = self.ref.child(text.lowercased())
                                    
                                    goalRef.setValue(goal.toAnyObject())
                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    @IBAction func LogoutDidTouch(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
