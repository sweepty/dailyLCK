//
//  TodayViewController.swift
//  LCKTarget
//
//  Created by Seungyeon Lee on 2018. 2. 13..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var ranks = [Ranking]()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshButton(_ sender: UIButton) {
        self.spinner.startAnimating()
        requestData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 35
        self.tableView.rowHeight = 35
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        requestData()
    }
    
    func requestData() {
        if let parsedData = parsePage() {
            ranks = parsedData

            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        } else {
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = "네트워크 연결 상태를 확인해주세요😣"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = .none
        }
        spinner.stopAnimating()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            
            self.preferredContentSize = CGSize(width: maxSize.width, height: self.tableView.rowHeight * 12)
        }
    }
    
}
extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ranks.count == 0 {
            return ranks.count
        } else {
            return ranks.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        if let contentCell = cell as? TodayRankingTableViewCell {
            if indexPath.row == 0 {
                contentCell.rankLabel.text = "순위"
                contentCell.teamLabel.text = "팀"
                contentCell.winLabel.text = "승"
                contentCell.loseLabel.text = "패"
                contentCell.differenceLabel.text = "승점"
                
                contentCell.rankLabel.font = .boldSystemFont(ofSize: 15.0)
                contentCell.teamLabel.font = .boldSystemFont(ofSize: 15.0)
                contentCell.winLabel.font = .boldSystemFont(ofSize: 15.0)
                contentCell.loseLabel.font = .boldSystemFont(ofSize: 15.0)
                contentCell.differenceLabel.font = .boldSystemFont(ofSize: 15.0)
            } else {
                contentCell.rankLabel.text = ranks[indexPath.row - 1].rank
                let teamName = ranks[indexPath.row - 1].team
                contentCell.teamLabel.text = changeShortName(teamName)
                contentCell.winLabel.text = ranks[indexPath.row - 1].win
                contentCell.loseLabel.text = ranks[indexPath.row - 1].lose
                contentCell.differenceLabel.text = Int(ranks[indexPath.row - 1].difference)! > 0 ? "+\(ranks[indexPath.row - 1].difference)" : ranks[indexPath.row - 1].difference
            }
        }
        return cell
    }
    
    
}
extension TodayViewController: UITableViewDelegate {
    
}
