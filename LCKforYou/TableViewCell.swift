//
//  TableViewCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 3. 12..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var cellView: UIView!

    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var img_leftTeam: UIImageView!
    @IBOutlet var img_rightTeam: UIImageView!
    
    @IBOutlet var leftTeamLabel: UILabel!
    @IBOutlet var rightTeamLabel: UILabel!
    
    //티켓팅 알람 설정 버튼
    @IBAction func btnTicket(_ sender: UIButton) {
    }
    
    //경기 시작 알람 설정 버튼
    @IBAction func btnMatch(_ sender: UIButton) {
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
