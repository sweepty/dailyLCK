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
        
//        items = realm.objects(schedule.self)
        items = realm.objects(match.self)

//        dateFormatter.dateFormat = "MM월 dd일"
    
        //중복되는 날이 없도록 함. 흠 근데 이거 쓰려면 새해마다 데이터 다 삭제해야겠네
//        for i in items! {
//            if matchup_dates.contains(i.mmdd_date) {
//
//            } else {
//                matchup_dates.append(i.mmdd_date)
//            }
//        }
        //날짜 순으로 정렬.
//        matchup_dates.sort()
        //test
//        print("04월 08일의 id:\(list["04월 08일"])")
//        print("key:\(list.values)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    // 각 섹션 당 셀수 얻기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count)!
    }
    
    // 셀 내용 변경하기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
//        cell.cellView.layer.cornerRadius = 10
        

        //realm
//        let item = items![indexPath.row]
        //현재 섹션의 튜플 가져오기
//        let sectiontitle = items![indexPath.section]
        
        //titleLabel
        cell.TitleLabel.text = "ggod"
//        cell.TitleLabel.text = items?.filter("matchup_date == %@",matchup_dates[indexPath.row])
//        cell.TitleLabel.text = items?.filter("matchdate <= %@ and >%@",[])
        //dateLabel
////        date to string
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from:matchup_dates[indexPath.section] as Date)
//        let starttmp = dateString+" 00:00:00"
//        let endtmp = dateString+" 12:59:59"
//        print("tmp시작날:\(starttmp)")
//        print("tmp끝나는날:\(endtmp)")
//        //string to date
////        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//
//        let start = dateFormatter.date(from: starttmp)
//        let end = dateFormatter.date(from: endtmp)
//        print("시작일:\(String(describing: start))")
//        print("끝나는날:\(String(describing: end))")
////        cell.TitleLabel.text = items?.filter("date contains[c] %@",dateString).value(forKey: "matchtitle") as! String
////        print("날짜당\(item.matchdate)")
////        print("스트링\(dateString)")
//        cell.TitleLabel.text = items?.filter("matchdate >= %@",matchup_dates[indexPath.section]) [indexPath.row].matchtitle
        

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

