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
        insertTeams()
    }
    
    func dataTask(url: String, method: String) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            let decoder = JSONDecoder()
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let data = data, let matchList = try? decoder.decode([Matches].self, from: data) {
                
                
                DispatchQueue(label: "background").async {
                    autoreleasepool {
                        let realm = try! Realm()
                        realm.beginWrite()
                        for m in matchList {
                            
                            
                            let matchItem = Match()
                            matchItem.id = m.matchId
                            matchItem.date = m.matchDate
                            matchItem.ticketDate = m.ticketDate
                            matchItem.teamLeft = m.leftTeam
                            matchItem.teamRight = m.rightTeam
                            matchItem.stadium = m.stadium
                            matchItem.season = m.seasonName
                            
                            realm.create(Match.self, value: matchItem)  
                        }
                        try! realm.commitWrite()
                    }
                    
                    
                }
                
            }
        }
        task.resume()
//        ScheduleViewController().tableView?.reloadData()
    }
    
    func insertTeams() {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:3000/teams")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let data = data, let teamList = try? decoder.decode([Teams].self, from: data) {
                
                DispatchQueue(label: "background").async {
                    autoreleasepool {
                        let realm = try! Realm()
                        
                        for t in teamList {
                            realm.beginWrite()
                            
                            let teamItem = Team()
                            teamItem.id = t.teamId
                            teamItem.name = t.teamName
                            teamItem.heart = false

                            
                            realm.create(Team.self, value: teamItem)
                            try! realm.commitWrite()
                        }
                    }
                }
                
            }
        }
        task.resume()
    }
}

