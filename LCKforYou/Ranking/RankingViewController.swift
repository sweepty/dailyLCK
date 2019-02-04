//
//  RankingViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 04/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import Kanna

class RankingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    struct Ranking {
//        let rank: String
        let logoURL: String
        let team: String
        let all: String
        let win: String
        let lose: String
        let difference: String
        
        init(logoURL: String, team: String, all: String, win: String, lose: String, difference: String) {
//            self.rank = rank
            self.logoURL = logoURL
            self.team = team
            self.all = all
            self.win = win
            self.lose = lose
            self.difference = difference
        }
    }
    
    var rankingList = [Ranking]()
    
    let baseURL = "http://www.leagueoflegends.co.kr/?m=esports&mod=chams_rank&cate=1"
    let imageBaseURL = "http://www.leagueoflegends.co.kr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        parsePage()

    }
    
    func parsePage() {
        guard let main = URL(string: baseURL) else {
            print("Error: \(baseURL) doesn't seem to be a valid URL")
            return
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
                
                let logo = info[teamIndex].at_xpath("img")!["src"] ?? "?"
                let team = info[teamIndex].text ?? "?"
                let all = info[allIndex].text ?? "?"
                let win = info[winIndex].text ?? "?"
                let lose = info[loseIndex].text ?? "?"
                let difference = info[differenceIndex].text ?? "?"
                
                let info = Ranking(logoURL: logo, team: team, all: all, win: win, lose: lose, difference: difference)
                rankingList.append(info)
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row != 0) {
            let rankCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let cell = rankCell as? RankingTableViewCell {
                cell.rankLabel.text = "\(indexPath.row)"
                cell.teamLabel.text = rankingList[indexPath.row - 1].team
                cell.allLabel.text = rankingList[indexPath.row - 1].all
                cell.winLabel.text = rankingList[indexPath.row - 1].win
                cell.loseLabel.text = rankingList[indexPath.row - 1].lose
                cell.differenceLabel.text = rankingList[indexPath.row - 1].difference
                
                let url = URL(string: imageBaseURL + rankingList[indexPath.row - 1].logoURL)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        cell.logoImageView.image = UIImage(data: data!)
                    }
                }
            }
            return rankCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            return cell
        }
        
    }
}
extension RankingViewController: UICollectionViewDelegate {
    
}
