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
    var pointsArray = [Int]()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)

        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()?.currentUser)!.uid)
        
            currentUser.observeSingleEvent(of: .value, with: { snapshot in

            let value = snapshot.value as? NSDictionary
            self.group = value?["group"] as! String
            self.name = value?["email"] as! String
            self.points = value?["points"] as! Int

            self.usersRef.queryOrdered(byChild: "group").queryEqual(toValue: self.group).observe(.value, with:
                { (snapshot) in
    
                    var newItems: [User] = []
                    
                    for item in snapshot.children {
                        
                        
                        let userItem = User(snapshot: item as! FIRDataSnapshot)
                        newItems.append(userItem)
                    }
                    
                    self.items = newItems
                    self.tableView.reloadData()
                    
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Ranking", image: UIImage(named: "icon-cover"), tag: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide empty cells of tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    // MARK: UITableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingCell
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
