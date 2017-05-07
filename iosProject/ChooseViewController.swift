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
        backgroundColor()
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
        let random = Int(arc4random_uniform(2))
        print(random)
        if random == 0 {
            self.selectRandom(name: "TicTacToe")
        }
        else {
            self.selectRandom(name: "RPS")
        }
    }
    
    func backgroundColor() {
        let backColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        view.backgroundColor = backColor
    }
    func selectRandom(name:String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: name) else {
            print("View controller toMain not found")
            return
        }
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
}
