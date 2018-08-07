//
//  Team.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 13/07/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Team: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var heart: Bool = false
    
    //primary key 설정
    override static func primaryKey() -> String? {
        return "id"
    }
}
