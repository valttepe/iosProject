//
//  OneScore.swift
//  iosProject
//
//  Created by iosdev on 7.5.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation

class OneScore {
    //Helper class for tableview information
    var you: String
    var opponent: String
    var win: Int
    var lose: Int
    var tie: Int
    
    init(you: String, opponent: String, win: Int, lose: Int, tie: Int){
        self.you = you
        self.opponent = opponent
        self.win = win
        self.lose = lose
        self.tie = tie
    }
    
    
    
}
