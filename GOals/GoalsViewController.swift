//
//  GoalsViewController.swift
//  GOals
//
//  Created by Fien Lute on 12-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    @IBOutlet weak var goalsTableView: UITableView!
    
    @IBOutlet weak var goalsViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set background mountains
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        // name first item tab bar
        tabBarItem = UITabBarItem(title: "Goals", image: UIImage(named: "avatar-icon"), tag: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
