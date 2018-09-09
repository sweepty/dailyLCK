//
//  MatchCodableModel.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/09/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import Foundation

struct Matches: Codable {
    var id: Int
    var date: Date
    var ticketDate: Date
    var teamLeft: String
    var teamRight: String
    var stadium: String
    var season: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case date = "match_date"
        case ticketDate = "ticket_date"
        case teamLeft = "left_team"
        case teamRight = "right_team"
        case stadium
        case season = "season_name"
    }
}
