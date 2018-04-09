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
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet weak var left_img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
