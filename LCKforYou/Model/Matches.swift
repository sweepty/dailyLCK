//
//  MatchCodableModel.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/09/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import Foundation

struct Matches: Codable {
    var matchId: Int
    var matchDate: Date
    var ticketDate: Date
    var leftTeam: String
    var rightTeam: String
    var stadium: String
    var seasonName: String
}
