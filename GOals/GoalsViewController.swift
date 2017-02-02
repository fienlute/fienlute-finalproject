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
    
    // MARK: Properties
    var senderDisplayName: String?
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var items: [Goal] = []
    var goal: Goal!
    var user: User!
    var group: String = ""
    var name: String = ""
    var pointsInt: Int = 0
    var pointsString: String = ""
    var completedBy: String = ""
       
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        title = "Goals"
        
        retrieveUserDataFirebase(retrieveGoalDataFirebase())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    // MARK : Actions 

    @IBAction func addGoalDidTouch(_ sender: Any) {
   
        let alert = UIAlertController(title: "Goal",
                                      message: "Add a new goal",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        
                                        let goalField = alert.textFields![0].text
                                        let pointsString = alert.textFields![1].text
                                        
           
                                        if goalField! == "" || pointsString == "" {
                                            self.errorAlert(title: "Error", alertCase: "Fill in all the fields")
                                        } else if self.isNumeric(a: pointsString!) {
                                            self.errorAlert(title: "Error", alertCase: "the points field should contain only numbers")
                                        } else {
                                        let pointsField: Int = Int(pointsString!)!
                                        let goalItem = Goal(name: goalField!, addedByUser: self.name, completed: false, points: pointsField, group: self.group, completedBy: self.completedBy)
                    
                                        let goalItemRef = self.goalRef.child((goalField?.lowercased())!)
                                        self.items.append(goalItem)
                                        goalItemRef.setValue(goalItem.toAnyObject())
                                        
                                        }
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
    
    // MARK: Methods
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
    }
    
    func errorAlert(title: String, alertCase: String) {
        let alert = UIAlertController(title: title, message: alertCase , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func retrieveUserDataFirebase(){
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUser = FIRDatabase.database().reference(withPath: "Users").child(self.user.uid)
            
            currentUser.observeSingleEvent(of: .value, with: { snapshot in
                
                let value = snapshot.value as? NSDictionary
                self.group = value?["group"] as! String
                self.name = value?["email"] as! String
                self.pointsInt = value?["points"] as! Int
                self.pointsString = String(self.pointsInt)
                
                self.retrieveGoalDataFirebase()
                
                })
            }
    }
    
    func retrieveGoalDataFirebase() {
        
        self.goalRef.queryOrdered(byChild: "group").queryEqual(toValue: self.group).observe(.value, with:
            { (snapshot) in
                
                self.goalRef.queryOrdered(byChild: "completedBy").queryEqual(toValue: "").observe(.value, with:
                    { (snapshot) in
                        
                        var newItems: [Goal] = []
                        
                        for item in snapshot.children {

                            let goalItem = Goal(snapshot: item as! FIRDataSnapshot)
                            newItems.append(goalItem)
                        }
                        self.items = newItems
                        self.tableView.reloadData()
                })
        })
    }
    
    /// Checks if input in textField is integer
    func isNumeric(a: String) -> Bool {
        return Double(a) == nil
    }
    
    // MARK: UITableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalsCell

        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.blue
        
        let goal = items[indexPath.row]
        
        cell.goalLabel.text = goal.name
        cell.addedByLabel.text = "Added by: " + goal.addedByUser
        cell.pointsLabel.text = String(goal.points) + " xp"

        toggleCellCheckbox(cell, isCompleted: goal.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let goal = items[indexPath.row]
        let toggledCompletion = !goal.completed
        let currentPointsInt = pointsInt + goal.points
        let userPointRef  = usersRef.child("points")
        let newCompletedBy = self.name
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child(self.user.uid)
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        
        goal.ref?.updateChildValues(["completed": toggledCompletion])

        pointsInt = currentPointsInt
        userPointRef.updateChildValues(["points":currentPointsInt])
        currentUser.child("points").setValue(pointsInt)
        
        goal.ref?.updateChildValues(["completedBy" : newCompletedBy])
        
        sleep(2)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = items[indexPath.row]
            goal.ref?.removeValue()
        }
    }
}
