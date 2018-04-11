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
import FSCalendar

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var calendarView: FSCalendar!
    //realm
    let realm = try! Realm()
    var items: Results<match>?
    
    //tableview section name List
    var matchup_dates : [String] = []
    var list :[String:[Int]] = [:]
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
    
    
    //event dot 뿌려주기
    var eventdates : [Date] = []
    
    //dateformatter(date to string, string to date)
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //CALENDAR
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 10, width: 320, height: 300))
//        calendar.dataSource = self
//        calendar.delegate = self
//        view.addSubview(calendar)
//        calendar.scrollDirection = .vertical
//        calendar.clipsToBounds = true
//        calendar.appearance.headerDateFormat = "yyyy년 MM월"
//        calendar.appearance.eventDefaultColor = UIColor.purple
        calendarView.dataSource = self
        calendarView.delegate = self
//        view.addSubview(calendar)
        calendarView.scrollDirection = .vertical
        calendarView.clipsToBounds = true
        calendarView.appearance.headerDateFormat = "yyyy년 MM월"
        calendarView.appearance.eventDefaultColor = UIColor.purple

        
        // Realm 저장 위치 보여줌
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        items = realm.objects(match.self)
        
        //TABLEVIEW
        //중복되는 날이 없도록 함. 흠 근데 이거 쓰려면 새해마다 데이터 다 삭제해야겠네
        for i in items! {
            if matchup_dates.contains(i.mmdd_date) {

            } else {
                matchup_dates.append(i.mmdd_date)
            }
        }
        //날짜 순으로 정렬.
        matchup_dates.sort()
        
        //CALENDAR
        //날짜 받아서 eventdots로 뿌려주기 위함.
        for event in items! {
            eventdates.append(event.matchdate)
        }

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
    
    //날짜 클릭시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        //eventdates는 matchdate가 모여있는 array임.
        for eventDate in eventdates {
            if self.gregorian.isDate(date, inSameDayAs: eventDate){
                
                //                //nil값이 나온다 고치기
                //                dateFormatter.dateFormat = "mm월 dd일"
                //                let dateString = dateFormatter.string(from: date)
                //
                //                //여기 어떻게 할지 생각...
                //                let test:[String] = matchup?.filter("mmdd_date ==%@",dateString).value(forKey: "teamLeft") as! [String]
                //임시
                return "경기날"
                
            }
        }
        return nil
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        //eventdates는 matchdate가 모여있는 array임.
        for eventDate in eventdates {
            if self.gregorian.isDate(date, inSameDayAs: eventDate){
                return 2
            }
        }
        return 0
    }
    
}

