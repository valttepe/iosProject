//
//  ScoreHandler.swift
//  iosProject
//
//  Created by iosdev on 2.5.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation
import CoreData

class ScoreHandler {
    
    func getOpponent(name: String) {
        print(name)
    }
    
    func getYourself() -> String {
        let check = UserDefaults.standard.bool(forKey: "LoggedIn")
        
        if check == true {
            let you:String = UserDefaults.standard.object(forKey: "User") as! String
            return you
        }
        else {
            return "Guest"
        }
        
    }
    
    
    
    
}
