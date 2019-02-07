//
//  DetailTableViewCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 07/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var blueLogoImageView: UIImageView!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redLogoImageView: UIImageView!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func alarmButton(_ sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
