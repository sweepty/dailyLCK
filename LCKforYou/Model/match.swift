//
//  match.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 4. 9..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Match: Object {
    @objc dynamic var id = 0
    @objc dynamic var date = Date()
    @objc dynamic var ticketDate = Date()
    @objc dynamic var teamLeft: String = ""
    @objc dynamic var teamRight: String = ""
    @objc dynamic var stadium: String = "" // 상암,강남, 그 외...
    @objc dynamic var season: String = "" // spring(LCK), summer(LCK), lift rivals, msi, world championship, kespa cup(LCK + 지역)
    
    //primary key 설정
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
extension Match {
    func writeToRealm(){
        try! uiRealm.write {
            uiRealm.add(self, update: true)
        }
    }
}
