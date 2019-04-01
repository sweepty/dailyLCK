//
//  TodayRankingTableViewCell.swift
//  LCKTarget
//
//  Created by Seungyeon Lee on 28/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import Kanna

class TodayRankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
