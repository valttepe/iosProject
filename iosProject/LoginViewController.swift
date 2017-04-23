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
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print(searchResults.count)
            
            for result in searchResults as [User] {
                print("User is \(result.username)!")
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
