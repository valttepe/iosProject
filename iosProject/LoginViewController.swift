//
//  LoginViewController.swift
//  iosProject
//
//  Created by iosdev on 23.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    let redColor: UIColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userField.layer.borderWidth = 1.0
        passField.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        let userFilter = userField.text!
        
        let passFilter = passField.text!
        
        let userPredicate = NSPredicate(format: "username = %@", userFilter)
        let passPredicate = NSPredicate(format: "password = %@", passFilter)
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [userPredicate, passPredicate])
        fetchRequest.predicate = andPredicate
        
        //fetchRequest.predicate = NSPredicate(format: "username == %@" , userFilter)
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print(searchResults.count)
            
            if searchResults.count == 0 {
                print("There was no such user")
                let alert = UIAlertController(title: "Invalid", message: "Username or password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            else {
                for result in searchResults as [User] {
                    print("User is \(result.username!)")
                    
                    if result.username == userField.text! && result.password == userField.text! {
                        print("Login was success")
                        
                        UserDefaults.standard.set(true, forKey: "LoggedIn")
                        UserDefaults.standard.setValue(result.username, forKey: "User")
                        _ = navigationController?.popViewController(animated: true)
                        
                    }
                    
                }
            }
            
            
                    }
        
        catch {
            print("Error: \(error)")
        }
        
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
