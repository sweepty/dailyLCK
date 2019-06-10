//
//  Requests.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 04/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class Requests {
    
    let formatter = DateFormatter()
    let decoder = JSONDecoder()
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func getMatchInfo(completion: @escaping ([Matches]?) -> Void) {
        guard let url = URL(string: API.baseURL) else {
            return
        }
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        Alamofire.request(urlRequest).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                self.formatter.timeZone = Calendar.current.timeZone
                self.decoder.dateDecodingStrategy = .formatted(self.formatter)
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let matches = response.data else {
                    return
                }
                do {
                    let matchList = try self.decoder.decode([Matches].self, from: matches)
                    completion(matchList)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                Log.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

