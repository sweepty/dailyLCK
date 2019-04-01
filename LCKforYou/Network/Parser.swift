//
//  Parser.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 28/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation
import Kanna

let baseURL = "https://www.leagueoflegends.co.kr/?m=esports&mod=chams_rank&cate=1"
let imageBaseURL = "https://www.leagueoflegends.co.kr"

func parseTitle() -> String {
    guard let main = URL(string: baseURL) else {
        return ""
    }
    if let lolMain = try? String(contentsOf: main, encoding: .utf8),
        let doc = try? HTML(html: lolMain, encoding: .utf8),
        let titlePath = doc.at_xpath("//header[@class='esports-header']//h2//strong")?.text {
        return setLeagueTitle(titlePath)
    } else {
        return ""
    }
}

func requestLogo(logoPath: String) -> UIImage? {
    let urlString = URL(string: imageBaseURL + logoPath)
    if let url = urlString, let contentData = try? Data(contentsOf: url) {
        guard let result = UIImage(data: contentData) else {
            return nil
        }
        return result
        
    } else {
        return nil
    }
}

func parsePage() -> [Ranking]? {
    var rankingList = [Ranking]()
    guard let main = URL(string: baseURL) else {
        print("Error: \(baseURL) URL이 잘못됨")
        return nil
    }
    do {
        
        let lolMain = try String(contentsOf: main, encoding: .utf8)
        let doc = try HTML(html: lolMain, encoding: .utf8)
        
        let info = doc.xpath("//div[@class='esports-body']//tbody//tr//td")
        
        let path = doc.xpath("//div[@class='esports-body']//tbody//tr")
        
        for (index, _) in path.enumerated() {
            
            let teamIndex = index * 6
            let allIndex = index * 6 + 1
            let winIndex = index * 6 + 2
            let loseIndex = index * 6 + 3
            let differenceIndex = index * 6 + 5
            
            let rank = info[teamIndex].parent?.at_xpath("th")?.text ?? ""
            let logo = info[teamIndex].at_xpath("img")!["src"] ?? ""
            let team = info[teamIndex].text ?? ""
            let all = info[allIndex].text ?? "0"
            let win = info[winIndex].text ?? "0"
            let lose = info[loseIndex].text ?? "0"
            let difference = info[differenceIndex].text ?? "0"
            
            let info = Ranking(rank: rank, logoURL: logo, team: team, all: all, win: win, lose: lose, difference: difference)
            rankingList.append(info)
        }
        return rankingList
        
    } catch let error {
        print("Error: \(error)")
        return nil
    }
}

func setLeagueTitle(_ title: String) -> String {
    let shortTitle = title.replacingOccurrences(of: "LoL 챔피언스 코리아", with: "LCK").replacingOccurrences(of: "스플릿", with: "")
    return shortTitle
}
