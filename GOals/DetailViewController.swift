//
//  DetailViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var goal: Goal!
    var items: [Goal] = []
    var group: String = ""
    var email: String = ""
    var name: String = ""
    var points: Int = 0
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()?.currentUser)!.uid)
    var goalName: String = ""
    var goalPoints: Int = 0
    var goalGroup: String = ""
    
    // MARK: Outlets
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var pointsUser: UILabel!
    @IBOutlet weak var tableView: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Initialize Tab Bar Item.
        tabBarItem = UITabBarItem(title: "Detail", image: UIImage(named: "icon-cover"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)

        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.group = value?["group"] as! String
            self.name = value?["email"] as! String
            self.points = value?["points"] as! Int
            self.nameUser.text! = self.name
            
            self.goalRef.queryOrdered(byChild: "completedBy").queryEqual(toValue: self.name).observe(.value, with:
                { (snapshot) in
                    
                    var newItems: [Goal] = []
                    
                    for item in snapshot.children {
                        
                        let goalItem = Goal(snapshot: item as! FIRDataSnapshot)
                        
                        newItems.append(goalItem)
                        
                        self.goalName = goalItem.name
                    }
                    
                    self.items = newItems
                    self.tableView.reloadData()
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        currentUser.child("points").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.pointsUser.text! = String(self.points) + " xp"
        })
        
        self.tableView.reloadData()
    }
    
    // MARK: UITableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let goal = items[indexPath.row]

        cell.completedGoalLabel.text = goal.name
        cell.completedPointsLabel.text = String(goal.points) + " xp"
        
        return cell
        
        

    }
}
