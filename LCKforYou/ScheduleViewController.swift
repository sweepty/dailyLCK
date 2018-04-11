//
//  ScheduleViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 12..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import Toaster
class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //realm
    let realm = try! Realm()
    var items: Results<match>?
    
    //tableview section name List
    var matchup_dates : [String] = []
    var list :[String:[Int]] = [:]
    
    
    //dateformatter(date to string, string to date)
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Realm 저장 위치 보여줌
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        items = realm.objects(match.self)
    
        //중복되는 날이 없도록 함. 흠 근데 이거 쓰려면 새해마다 데이터 다 삭제해야겠네
        for i in items! {
            if matchup_dates.contains(i.mmdd_date) {

            } else {
                matchup_dates.append(i.mmdd_date)
            }
        }
        //날짜 순으로 정렬.
        matchup_dates.sort()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //각 섹션 당 셀 수 얻기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.filter("mmdd_date ==%@",matchup_dates[section]).count)!
    }
    
    // 셀 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
        
        //date to string
        dateFormatter.dateFormat = "hh시"
        let data = items?.filter("mmdd_date == %@",matchup_dates[indexPath.section])[indexPath.row]
        let startTime = dateFormatter.string(from:(data?.matchdate)!)
        cell.TitleLabel.text = data?.matchtitle
        cell.dateLabel.text = startTime
        return cell
    }
    
    //테이블 섹션 명
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(matchup_dates[section])"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchup_dates.count
    }
    
}

