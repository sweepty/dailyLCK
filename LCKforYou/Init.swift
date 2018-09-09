//
//  Init.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 8. 8..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class Init {
    var realm: Realm!
    let dateFormatter = DateFormatter()
    var notificationToken: NotificationToken!
    
    init() {
        realm = try! Realm()
        
        dataTask(url: "http://127.0.0.1:3000/matches", method: "GET")

        Team.add(1, "Afreeca", false)
        Team.add(2, "Gen.G", false)
        Team.add(3, "Griffin", false)
        Team.add(4, "Hanwha", false)
        Team.add(5, "Jin Air", false)
        Team.add(6, "KING-ZONE", false)
        Team.add(7, "KT", false)
        Team.add(8, "MVP", false)
        Team.add(9, "SKT", false)
        Team.add(10, "bbq", false)

    }
    
    func dataTask(url: String, method: String) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            let decoder = JSONDecoder()
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            decoder.dateDecodingStrategy = .formatted(self.dateFormatter)

            if let data = data, let matchList = try? decoder.decode([Matches].self, from: data) {

                DispatchQueue(label: "background").async {
                    autoreleasepool {
                        let realm = try! Realm()
                        
                        for m in matchList {
                            realm.beginWrite()
                            
                            let matchItem = Match()
                            matchItem.id = m.id
                            matchItem.date = m.date
                            matchItem.ticketDate = m.ticketDate
                            matchItem.teamLeft = m.teamLeft
                            matchItem.teamRight = m.teamRight
                            matchItem.stadium = m.stadium
                            matchItem.season = m.season
                            
                            realm.create(Match.self, value: matchItem)
                            try! realm.commitWrite()
                        }
                    }
                }

            }
        }
        task.resume()
        
    }
}

