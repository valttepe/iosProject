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
    @IBOutlet weak var loginButton: UIButton!
   
    //Testing
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        // making a little rounding to button
        self.loginButton.layer.cornerRadius = 4
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.scoreHandler.getPlayerScores()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //testing for scores 
    
//    @IBAction func TieButton(_ sender: Any) {
//        appDelegate.scoreHandler.getResultsFromGame(name: "TestOpponent", res: "Tie")
//    }
//    
//    @IBAction func WinButton(_ sender: Any) {
//        appDelegate.scoreHandler.getResultsFromGame(name: "TestOpponent", res: "Win")
//    }
//    
//    @IBAction func LoseButton(_ sender: Any) {
//        appDelegate.scoreHandler.getResultsFromGame(name: "TestOpponent1", res: "Lose")
//    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        //Fetches with two predicates at the same time
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
                //User was found and it adds to userdefaults most crucial data from it like username and boolean value and sends back to main page
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
    
    
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
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
