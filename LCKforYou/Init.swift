//
//  Init.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 8. 8..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Init {
    var realm: Realm!
    
    init() {
        realm = try! Realm()
        
        Team.add(1, "Afreeca Freecs", false)
        Team.add(2, "Gen.G", false)
        Team.add(3, "Griffin", false)
        Team.add(4, "Hanwha Life Esports", false)
        Team.add(5, "Jin Air Greenwings", false)
        Team.add(6, "KING-ZONE DragonX", false)
        Team.add(7, "KT Rolster", false)
        Team.add(8, "MVP", false)
        Team.add(9, "SK Telecom T1", false)
        Team.add(10, "bbq Olivers", false)
        
    }
}
