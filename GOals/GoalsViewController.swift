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
    
    enum Section: Int {
        case createNewGroupSection = 0
        case currentGroupsSection
}
    // MARK: Properties
    var senderDisplayName: String?
    var newGroupTextField: UITextField?
    private var groups: [Group] = []
    private lazy var groupRef: FIRDatabaseReference = FIRDatabase.database().reference().child("groups")
    private var groupRefHandle: FIRDatabaseHandle?

//    let listToUsers = "ListToUsers"
//    var groupItems: [Group] = []
//    let groupRef = FIRDatabase.database().reference(withPath: "groups")
//    var items: [Goal] = []
//    let ref = FIRDatabase.database().reference(withPath: "goals")
//    let usersRef = FIRDatabase.database().reference(withPath: "online")
//    var user: User!
//    var userCountBarButtonItem: UIBarButtonItem!
//    var group: Group!
//    var goal: Goal!
//    
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)

        title = "RW RIC"
        observeGroups()
    }
    
    deinit {
        if let refHandle = groupRefHandle {
            groupRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    
    // MARK :Actions
    @IBAction func createGroup(_ sender: Any) {
        if let name = newGroupTextField?.text { // 1
            let newGroupRef = groupRef.childByAutoId() // 2
            let groupItem = [ // 3
                "name": name
            ]
            newGroupRef.setValue(groupItem) // 4
        }
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
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewGroupSection:
                return 1
            case .currentGroupsSection:
                return groups.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewGroupSection.rawValue ? "NewGroup" : "ExistingGroup"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewGroupSection.rawValue {
            if let createNewGroupCell = cell as? GroupCell {
                newGroupTextField = createNewGroupCell.newChannelNameField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentGroupsSection.rawValue {
            cell.textLabel?.text = groups[(indexPath as NSIndexPath).row].name
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentGroupsSection.rawValue {
            let group = groups[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "showGoals", sender: group)
        }
    }
    
    // MARK: Firebase related methods
    private func observeGroups() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        groupRefHandle = groupRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let groupData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = groupData["name"] as! String!, name.characters.count > 0 { // 3
                self.groups.append(Group(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    

    
//    override func viewDidLoad() {
//        super.viewDidLoad()

        
//        // TODO: if a user is not in a group, give alert
//            
//        // Set background mountains.
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
//        
//        // Name first item tab bar.
//        tabBarItem = UITabBarItem(title: "Goals", image: UIImage(named: "avatar-icon"), tag: 0)
//        
//        // Add groups.
//        ref.observe(.value, with: { snapshot in
//            var newGroups: [Group] = []
//            
//            for item in snapshot.children {
//                let group = Group(snapshot: item as! FIRDataSnapshot)
//                newGroups.append(group)
//            }
//        })
//
//        // Put goal into array. (works)
//        self.ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
//            var newItems: [Goal] = []
//            for item in snapshot.children {
//                let goal = Goal(snapshot: item as! FIRDataSnapshot)
//                newItems.append(goal)
//            }
//            
//            self.items = newItems
//            self.tableView.reloadData()
//        })
//        
//        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = User(authData: user)
//            let currentUserRef = self.usersRef.child(self.user.uid)
//            currentUserRef.setValue(self.user.email)
//            currentUserRef.onDisconnectRemoveValue()
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: UITableView Delegate methods
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalsCell
//        let goal = items[indexPath.row]
//
//        cell.labelGoal?.text = goal.name
//        cell.labelUser?.text = "added by: " + goal.addedByUser
//        cell.labelPoints?.text = String(goal.points) + " xp"
//
//        toggleCellCheckbox(cell, isCompleted: goal.completed)
//        
//        return cell
//    }
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
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        let goal = items[indexPath.row]
//        let toggledCompletion = !goal.completed
//        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
//        goal.ref?.updateChildValues([
//            "completed": toggledCompletion
//            ])
//    }
//    
//    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
//        if !isCompleted {
//            cell.accessoryType = .none
//            cell.textLabel?.textColor = UIColor.black
//            cell.detailTextLabel?.textColor = UIColor.black
//        } else {
//            cell.accessoryType = .checkmark
//            cell.textLabel?.textColor = UIColor.gray
//            cell.detailTextLabel?.textColor = UIColor.gray
//        }
//    }
//    
//    // Add group.
//    @IBAction func addGroup(_ sender: Any) {
//        let alert = UIAlertController(title: "Group",
//                                      message: "Add a new group",
//                                      preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { _ in
//
//                                        guard let textField = alert.textFields?.first,
//                                            let text = textField.text else { return }
//                                        
////                                        let groupItem = Group(name: text, goals: self.items)
////
////                                        let groupItemRef = self.groupRef.child(text.lowercased())
////                                        groupItemRef.setValue(groupItem.toAnyObject())
//                                        
//                                        
//                                        if let name = textField.text { // 1
//                                            let groupItemRef = self.groupRef.childByAutoId() // 2
//                                            let groupItem = [ // 3
//                                                "name": name
//                                            ]
//                                            groupItemRef.setValue(groupItem) // 4
//                                        }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField()
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//
//    // MARK: Add Item.
//    @IBAction func addButtonDidTouch(_ sender: Any) {
//    let alert = UIAlertController(title: "Goal",
//                                      message: "Add a new goal",
//                                      preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { action in
//                                        let goalField = alert.textFields![0].text
//                                        let points: Int = Int(alert.textFields![1].text!)!
//                                        let goal = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points)
//                                        
//                                        let goalRef = self.ref.child(goalField!)
//                                        
//                                        goalRef.setValue(goal.toAnyObject())
//                                        
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField { textGoal in
//            textGoal.placeholder = "Enter a new goal"
//        }
//        
//        alert.addTextField { textPoints in
//            textPoints.placeholder = "How many points is this worth?"
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    @IBAction func LogoutDidTouch(_ sender: Any) {
//        let firebaseAuth = FIRAuth.auth()
//        do {
//            try firebaseAuth?.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        // hide empty cells of tableview 
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//    }
//    
//    
//    
}
