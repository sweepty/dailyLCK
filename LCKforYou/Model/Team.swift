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
    @objc dynamic var name: String = ""
    @objc dynamic var heart: Bool = false
    
    //primary key 설정
    override static func primaryKey() -> String? {
        return "name"
    }
    
    static func add(_ name: String, _ heart: Bool) {
        let realm = try! Realm()
        let team = Team()
        
        team.name = name
        team.heart = heart
        
        try! realm.write {
            realm.add(team)
        }
    }
    
    static func updateHeart(_ name: String, _ heart: Bool) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(Team.self, value: ["name": name, "heart": heart], update: true)
        }
    }
}
