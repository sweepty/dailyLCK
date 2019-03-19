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

    func getMatchInfo(completion: @escaping ([Matches]?) -> Void) {
        // ????
        Alamofire.request(API.baseURL).validate().responseJSON { response in
            print("Result: \(response.result)")
            switch response.result {
            case .success:
                print("성공")
                let decoder = JSONDecoder()
                self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let data = response.data, let matches = try? decoder.decode([Matches].self, from: data) {
                    completion(matches)
                }
            case .failure(let error):
                print("실패")
                print(error)
                completion(nil)
            }
        }
        print("ㄴ넘어감")
    }
    
    func insertTeams(_ completion: @escaping(Bool, [Teams]?) -> Void) {
        let teamURL = API.baseURL + "teams"
        Alamofire.request(teamURL).validate().responseJSON { response in
            print("Result: \(response.result)")
            switch response.result {
            case .success:
                print("성공쓰")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let data = response.data, let teams = try? decoder.decode([Teams].self, from: data) {
                    completion(true, teams)
                }
            case .failure(let error):
                print("실패쓰")
                print(error)
                completion(false, nil)
            }
        }
        print("ㄴ넘어감")
    }
}

