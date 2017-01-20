//
//  DetailsGroupViewController.swift
//  GOals
//
//  Created by Fien Lute on 19-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase

// MARK: Outlets



class DetailsGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
//    var groupRef: FIRDatabaseReference?
//    private lazy var goalRef: FIRDatabaseReference = self.groupRef!.child("goals")
    
    
    var groupRef = FIRDatabase.database().reference().child("goals")
    private var newGoalRefHandle: FIRDatabaseHandle?
    private var updatedGoalRefHandle: FIRDatabaseHandle?
    var group: Group? {
        didSet {
            title = group?.name
        }
    }
    var goals = [Goal]()
    
    let listToUsers = "ListToUsers"
    var items: [Goal] = []
    var user = User(authData: (FIRAuth.auth()?.currentUser)!)
    var groupItems: [Group] = []
    var userCountBarButtonItem: UIBarButtonItem!
    var goal: Goal!

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
//    
    // MARK: methods
    @IBAction func addGoal(_ sender: Any) {
        let alert = UIAlertController(title: "Goal",
                                        message: "Add a new goal",
                                              preferredStyle: .alert)
        
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { action in
                                            let goalField = alert.textFields![0].text
                                            let points: Int = Int(alert.textFields![1].text!)!
                                            let itemRef = self.groupRef.childByAutoId()
                                            
                                            print(goalField!)
                                            print(User(authData: (FIRAuth.auth()?.currentUser)!))
                                            print(points)
                                            
                                            let goalItem = Goal(name: goalField!, addedByUser: self.user.email, completed: false, points: points)
                                            
                                        
                                            
                                            itemRef.setValue(goalItem)

                                            self.groupRef = self.groupRef.child("goals")
                                        
                                            self.groupRef.setValue(goalItem.toAnyObject())
                                            
                                            self.goals.append(self.goal)
                                            
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
