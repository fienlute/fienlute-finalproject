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

    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var pointsUser: UILabel!
    
    var group: String = ""
    var email: String = ""
    
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Detail", image: UIImage(named: "icon-cover"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        

        // set background mountains
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
