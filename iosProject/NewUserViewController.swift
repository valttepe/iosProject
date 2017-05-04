//
//  NewUserViewController.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController{

    @IBOutlet weak var newUserField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    
    let greenColor: UIColor = UIColor.green
    let redColor: UIColor = UIColor.red
    
    let userClassName:String = String(describing: User.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rePasswordField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didChangeText(textField:UITextField) {
        if textField.text == passwordField.text! {
            passwordField.layer.borderColor = self.greenColor.cgColor
            rePasswordField.layer.borderColor = self.greenColor.cgColor
            passwordField.layer.borderWidth = 1.0
            rePasswordField.layer.borderWidth = 1.0
            print("Yes")
        } else {
            passwordField.layer.borderColor = self.redColor.cgColor
            rePasswordField.layer.borderColor = self.redColor.cgColor
            passwordField.layer.borderWidth = 1.0
            rePasswordField.layer.borderWidth = 1.0
            
            
            print("no")
        }
    }
    

    
    
    @IBAction func createButton(_ sender: UIButton) {
        print(self.newUserField.text!)
        
        var username = self.newUserField.text!
        var password = self.passwordField.text!
        var rePassword = self.rePasswordField.text!
        
        if username.isEmpty {
            newUserField.layer.borderColor = self.redColor.cgColor
            newUserField.layer.borderWidth = 1.0
        }
        else if password.isEmpty{
            passwordField.layer.borderColor = self.redColor.cgColor
            passwordField.layer.borderWidth = 1.0
        }
        else if rePassword.isEmpty {
            rePasswordField.layer.borderColor = self.redColor.cgColor
            rePasswordField.layer.borderWidth = 1.0
        }
        
        else {
            print("success")
            let deviceName: String = UIDevice.current.name
            let user:User = NSEntityDescription.insertNewObject(forEntityName: self.userClassName , into: DatabaseController.getContext()) as! User
            
            user.username = username
            user.device = deviceName
            user.password = password
            user.lose = 0
            user.tie = 0
            user.win = 0
            DatabaseController.saveContext()
            
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            UserDefaults.standard.setValue(username, forKey: "User")
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {
                print("View controller toMain not found")
                return
            }
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
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
