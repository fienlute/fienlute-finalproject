//
//  LoginViewController.swift
//  GOals
//
//  Created by Fien Lute on 10-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let loginToList = "LoginToList"

    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountainbackgroundgoals.png")!)
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
        }
    }
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!)
    }

    @IBAction func signupDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
           style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                       password: passwordField.text!) { user, error in
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                           password: self.textFieldLoginPassword.text!)
                } else {
                    print("ERROR: \(error)")
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
    
}

