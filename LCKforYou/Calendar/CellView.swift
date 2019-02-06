//
//  CalendarCustomCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 26/11/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CellView: JTAppleCell {
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var listStackView: UIStackView!
    
    // 셀 재사용 전에 설정해줌.
    // 중복되어서 이상하게 나타나는 현상 해결
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedView.isHidden = true
        
        for subview in listStackView.subviews {
            subview.removeFromSuperview()
            
        }
    }
}
