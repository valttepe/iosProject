//
//  ChooseViewController.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstGameTap(_ sender: UITapGestureRecognizer) {
        print("First pressed")
    }
    
    @IBAction func secondGameTap(_ sender: UITapGestureRecognizer) {
        print("Second pressed")
    }
 
    @IBAction func RandomTap(_ sender: UITapGestureRecognizer) {
        print("Random pressed")
    }
    

}
