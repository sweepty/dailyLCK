//
//  Ranking.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 28/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation

struct Ranking {
    let rank: String
    let logoURL: String
    let team: String
    let all: String
    let win: String
    let lose: String
    let difference: String
    
    init(rank: String, logoURL: String, team: String, all: String, win: String, lose: String, difference: String) {
        self.rank = rank
        self.logoURL = logoURL
        self.team = team
        self.all = all
        self.win = win
        self.lose = lose
        self.difference = difference
    }
}
