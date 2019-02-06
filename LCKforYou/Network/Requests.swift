//
//  Requests.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 04/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import Alamofire

class Requests {
    var realm: Realm!
    let dateFormatter = DateFormatter()
    var notificationToken: NotificationToken!

    func getMatchInfo(completion: @escaping (Bool, [Matches]) -> Void) {
        // ????
        Alamofire.request(API.baseURL).validate().responseJSON { response in
            print("Result: \(response.result)")
            switch response.result {
            case .success:
                print("성공쓰")
            case .failure(let error):
                print("실패쓰")
                print(error)
            }
            
            if String(response.result.description) == "FAILURE" {
                DispatchQueue.main.async {
                    completion(false, CalendarViewController.matchList)
                }
            } else {
                let decoder = JSONDecoder()
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let data = response.data, let matches = try? decoder.decode([Matches].self, from: data) {
                    CalendarViewController.matchList = matches
                    DispatchQueue.main.async {
                        completion(true, CalendarViewController.matchList)
                    }
                }
            }
        }
        print("ㄴ넘어감")
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

