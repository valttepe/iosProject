//
//  ScoreTableViewCell.swift
//  iosProject
//
//  Created by iosdev on 26.4.2017.
//  Copyright © 2017 iosdev. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winStreak: UILabel!
    @IBOutlet weak var tieStreak: UILabel!
    @IBOutlet weak var loseStreak: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
