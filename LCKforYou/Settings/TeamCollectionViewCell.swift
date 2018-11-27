//
//  TeamCollectionViewCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/08/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamBoxView: UIView!
    
    override var isSelected: Bool {
        didSet {
            self.teamBoxView.layer.borderWidth = 2
            self.teamBoxView.layer.borderColor = self.teamBoxView.layer.borderColor == UIColor.red.cgColor ? UIColor.clear.cgColor : UIColor.red.cgColor
        }
    }
}
