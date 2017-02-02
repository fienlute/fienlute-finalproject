//
//  RankingViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RankingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    var goalRef =  FIRDatabase.database().reference(withPath: "goals")
    let usersRef = FIRDatabase.database().reference(withPath: "Users")
    var user: User!
    var items: [User] = []
    var group: String = ""
    var name: String = ""
    var points: Int = 0
    var pointsArray: [Int] = []
    var goalGroup: String = ""
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "Ranking", image: UIImage(named: "icon-cover"), tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        retrieveUserDataFirebase(retrieveGoalDataFirebase())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    // MARK: Actions
    func retrieveUserDataFirebase() {
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()?.currentUser)!.uid)
        
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            self.group = value?["group"] as! String
            self.name = value?["email"] as! String
            self.points = value?["points"] as! Int
        })
    }
    
    func retrieveGoalDataFirebase() {
        let sortedRef = FIRDatabase.database().reference(withPath: "Users").queryOrdered(byChild: "group").queryEqual(toValue : self.group)
        
        sortedRef.observe(.value, with: { snapshot in
            
            var newItems: [User] = []
            
            for item in snapshot.children {
                
                let userItem = User(snapshot: item as! FIRDataSnapshot)
                newItems.append(userItem)
                
            }
            
            self.items = newItems
            
            self.usersRef.queryOrdered(byChild: "points").observe(.value, with: { snapshot in
                
                var orderedItems: [User] = []
                
                for item in snapshot.children {
                    
                    let userItem = User(snapshot: item as! FIRDataSnapshot)
                    orderedItems.append(userItem)
                }
                orderedItems = orderedItems.reversed()
                self.items = orderedItems
                self.tableView.reloadData()
            })
        })
    }
    
    // MARK: UITableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        let user = items[indexPath.row]
        let points = user.points

        cell.userRankingLabel.text = user.email
        cell.userPointsLabel.text = String(points) + " xp"
        
        pointsArray.append(points)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        
        _ = items[indexPath.row]

    }
 }
