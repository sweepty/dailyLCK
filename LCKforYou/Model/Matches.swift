//
//  MatchCodableModel.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/09/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import Foundation

struct Matches: Codable {
    var _id: String
    var blue: String
    var red: String
    var stadium: String
    var mDate: Date
    var tDate: Date
    var isplayoff: Bool
    var season: String
}
