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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.tableView.estimatedRowHeight = 35
        self.tableView.rowHeight = 35
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        if let parsedData = parsePage() {
            ranks = parsedData
        } else {
            print("파싱 못함.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            self.preferredContentSize = CGSize(width: maxSize.width, height: self.tableView.rowHeight * 11)
        }
    }
    
}
extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        if let contentCell = cell as? TodayRankingTableViewCell {
            if indexPath.row == 0 {
                contentCell.rankLabel.text = "순위"
                contentCell.teamLabel.text = "팀"
                contentCell.winLabel.text = "W"
                contentCell.loseLabel.text = "L"
                contentCell.differenceLabel.text = "승점"
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
