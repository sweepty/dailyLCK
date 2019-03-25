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

var realm: Realm!
var notificationToken: NotificationToken!

let formatter = DateFormatter()
let decoder = JSONDecoder()

func getMatchInfo(completion: @escaping ([Matches]?) -> Void) {
    var urlRequest = URLRequest(url: URL(string: API.baseURL)!)
    urlRequest.cachePolicy = .reloadIgnoringCacheData
    
    Alamofire.request(urlRequest).validate().responseJSON { response in
        switch response.result {
        case .success:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = Calendar.current.timeZone
            decoder.dateDecodingStrategy = .formatted(formatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let data = response.data, let matches = try? decoder.decode([Matches].self, from: data) {
                completion(matches)
            }
        case .failure(let error):
            Log.error(error.localizedDescription)
            completion(nil)
        }
    }
}

func insertTeams(_ completion: @escaping(Bool, [Teams]?) -> Void) {
    let teamURL = API.baseURL + "teams"
    var urlRequest = URLRequest(url: URL(string: teamURL)!)
    urlRequest.cachePolicy = .reloadIgnoringCacheData
    
    Alamofire.request(urlRequest).validate().responseJSON { response in
        switch response.result {
        case .success:
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let data = response.data, let teams = try? decoder.decode([Teams].self, from: data) {
                completion(true, teams)
            }
        case .failure(let error):
            Log.error(error.localizedDescription)
            completion(false, nil)
        }
    }
}

