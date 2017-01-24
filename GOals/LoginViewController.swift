//
//  LoginViewController.swift
//  GOals
//
//  Created by Fien Lute on 10-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    var ref: FIRDatabaseReference!
    let loginToList = "LoginToList"
    //let defaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref =  FIRDatabase.database().reference(withPath: "Users")
       // Set background to mountains.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
    
            if user != nil {
    
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!) {
        (user, error) in
        if error != nil {
            self.errorAlert(title: "Login Failed", alertCase: "error")
            }
        //self.performSegue(withIdentifier: "LoginToList", sender: nil)
        }
    }

    @IBAction func signupDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
    
        let saveAction = UIAlertAction(title: "Save",
           style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            let groupField = alert.textFields![2]
            
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                       password: passwordField.text!) { user, error in
                if error == nil {
                    
                    let user = User(uid: (user?.uid)!, email: emailField.text!, group: groupField.text!, points: 0)
                    
                    FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                           password: self.textFieldLoginPassword.text!)
                    
                    let userRef = self.ref.child((user.uid))
                    userRef.setValue(user.toAnyObject())

                } else {
                    self.errorAlert(title: "Signup failed", alertCase: "Enter a valid email adress, password and group")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addTextField { textGroup in
            textGroup.placeholder = "Add a group/Join a group"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }

    extension LoginViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == textFieldLoginEmail {
                textFieldLoginPassword.becomeFirstResponder()
            }
            if textField == textFieldLoginPassword {
                textField.resignFirstResponder()
            }
            return true
        }

    func errorAlert(title: String, alertCase: String) {
    let alert = UIAlertController(title: title, message: alertCase , preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }

    

    // MARK: Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        let navVc = segue.destination as! UINavigationController // 1
//        let GoalsViewController = navVc.viewControllers.first as! GoalsViewController // 2
//        
//        DetailViewController.nameUser.text = textFieldLoginEmail?.text // 3
//    }
}


