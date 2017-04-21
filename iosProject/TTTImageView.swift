//
//  TTTImageView.swift
//  iosProject
//
//  Created by iosdev on 21.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class TTTImageView: UIImageView {

    var player:String?
    var activated:Bool! = false
    
    func setPlayer (_player:String) {
        self.player = _player
        
        if activated == false {
            if _player == "x" {
                self.image = UIImage(named: "x")
            }
            else {
                self.image = UIImage(named: "o")
            }
            activated = true
        }
    }

}
