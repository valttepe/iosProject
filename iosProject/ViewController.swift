//
//  ViewController.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var scoresButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        
        //self.scoresButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfLogged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TODO: make sure that it doesn't use values if not logged in
    func checkIfLogged () {
        let check = UserDefaults.standard.bool(forKey: "LoggedIn")
        
        if check == true{
            let userName:String = UserDefaults.standard.object(forKey: "User") as! String
            print(check)
            print(userName)
            self.loginText.text = "Logged in as \(userName)"
            //hides login button and shows scores button
            self.loginButton.title = ""
            self.loginButton.isEnabled = false
            self.scoresButton.title = "Scores"
            self.scoresButton.isEnabled = true
        }
        else {
            //Hides scores button shows loging button
            self.loginText.text = "Logged in as Guest"
            self.scoresButton.title = ""
            self.scoresButton.isEnabled = false

            
        }
        
        
    }
    // Sends alert if x is pressed. We had plans that there is shutdown in here but this is enough
    @IBAction func xButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You can play even without problems", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // background color function. Didn't have time to make one instance so this is in every viewcontroller. 
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
    }

}

