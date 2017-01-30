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

class DetailViewController: UIViewController {

    
    // MARK: Properties
    var goal: Goal!
    var items: [Goal] = []
    var group: String = ""
    var email: String = ""
    
    
    // MARK: Outlets
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var pointsUser: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Initialize Tab Bar Item.
        tabBarItem = UITabBarItem(title: "Detail", image: UIImage(named: "icon-cover"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var points: Int = 0
        let currentUser = FIRDatabase.database().reference(withPath: "Users").child((FIRAuth.auth()!.currentUser?.uid)!)
        currentUser.observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            self.email = value?["email"] as! String
            points = value?["points"] as! Int
            let points = points
            
            self.nameUser.text! = self.email
            self.pointsUser.text! = String(points) + " XP"
            })
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingCell
//        let user = items[indexPath.row]
//        let points = user.points
//        
//        cell.userRankingLabel.text = user.email
//        cell.userPointsLabel.text = String(points)
//        
//        pointsArray.append(points)
//        
//        return cell
//    }
//    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let detailVC = segue.destination as? DetailViewController {
//            detailVC. = .toString() }
//    }
}
