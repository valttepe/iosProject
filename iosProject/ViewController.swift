//
//  ViewController.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkIfLogged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TODO: make sure that it doesn't use values if not logged in
    func checkIfLogged () {
        let check = UserDefaults.standard.bool(forKey: "LoggedIn")
        
        if check == true{
            let userName = UserDefaults.standard.object(forKey: "User")
            print(check)
            print(userName!)
            
            
        }
        
        
    }
    
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
    }

}

