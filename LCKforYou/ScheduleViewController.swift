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
import EventKit
import UserNotifications

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
    
    //dateformatter(date to string, string to date)
    let dateFormatter = DateFormatter()
    
    //현재 날짜 시간
    let date = NSDate()
    
    //event dot 뿌려주기
    var eventdates : [Date] = []
    
    //미리 알림 event
    var eventStore: EKEventStore?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 100.0
        
        
        
        //calendar 설정
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollDirection = .vertical
        calendarView.clipsToBounds = true
        calendarView.appearance.headerDateFormat = "yyyy년 MM월"
        calendarView.appearance.headerTitleColor = UIColor.black
        
        
        // Realm 저장 위치 보여줌
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        items = realm.objects(match.self)
        
        
        for i in items! {
            //calendar용
            //날짜 받아서 eventdots로 뿌려주기 위함.
            eventdates.append(i.matchdate)
            
            //tableview section용
            if matchup_dates.contains(i.mmdd_date) {
                
            } else {
                matchup_dates.append(i.mmdd_date)
            }
        }
        dateFormatter.dateFormat = "MM월 dd일"
        let today = dateFormatter.string(from: date as Date)
        print(today)
        
        //오늘 경기가 없지만 유저에게 오늘 경기가 없다는 것을 보여주기 위해서 추가
        if !matchup_dates.contains(today) {
            matchup_dates.append(today)
        }
        //날짜 순으로 정렬.
        matchup_dates.sort()
        
        //local notification
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //    테이블 섹션 명
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(matchup_dates[section])"
    }
    
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchup_dates.count
    }
    
    //각 섹션 당 셀 수 얻기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (items?.filter("mmdd_date ==%@",matchup_dates[section]).count)!
    }
    
    //요일 만들기
    func getDayOfWeek(today:Date)->String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: date as Date)
        let todayDate = dateFormatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        
        switch weekDay {
        case 1: return "SUN"
        case 2: return "MON"
        case 3: return "TUE"
        case 4: return "WED"
        case 5: return "THR"
        case 6: return "FRI"
        case 7: return "SAT"
        default: return "ERROR"
        }
    }
    
    
    // 셀 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
        
        //        cell.backgroundColor = UIColor.black
        //        cell.monthLabel.textColor = UIColor.white
        //        cell.dayLabel.textColor = UIColor.white
        //        cell.weekLabel.textColor = UIColor.white
        //        cell.timeLabel.textColor = UIColor.white
        //        cell.leftTeamLabel.textColor = UIColor.white
        //        cell.rightTeamLabel.textColor = UIColor.white
        cell.layoutMargins.bottom = 30.0
        
        //items
        let data = items?.filter("mmdd_date == %@",matchup_dates[indexPath.section])[indexPath.row]
        
        dateFormatter.dateFormat = "hh:mm"
        let startTime = dateFormatter.string(from:(data?.matchdate)!)
        
        //MM으로 할지 경기장으로 할지? 우선 경기장으로
        cell.monthLabel.text = data?.stadium
        dateFormatter.dateFormat = "dd"
        let dayday = dateFormatter.string(from: (data?.matchdate as Date?)!)
        cell.dayLabel.text = dayday
        cell.weekLabel.text = getDayOfWeek(today: (data?.matchdate)!)
        cell.timeLabel.text = "PM \(startTime)"
        cell.leftTeamLabel.text = data?.teamLeft
        cell.rightTeamLabel.text = data?.teamRight
        
        
        //왼쪽 팀 image
        switch data?.teamLeft {
        case "SKT": cell.img_leftTeam.image = UIImage(named: "skt.png")
        case "AFs": cell.img_leftTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_leftTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_leftTeam.image = UIImage(named: "jag.png")
        case "KSV": cell.img_leftTeam.image = UIImage(named: "ksv.png")
        case "KT": cell.img_leftTeam.image = UIImage(named: "kt.png")
        case "ROX": cell.img_leftTeam.image = UIImage(named: "rox.png")
        case "KZ": cell.img_leftTeam.image = UIImage(named: "kz.png")
        default: cell.img_leftTeam.image = UIImage(named: "skt.png")
        }
        
        //오른쪽 팀 img
        switch data?.teamRight {
        case "SKT": cell.img_rightTeam.image = UIImage(named: "skt.png")
        case "AFs": cell.img_rightTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_rightTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_rightTeam.image = UIImage(named: "jag.png")
        case "KSV": cell.img_rightTeam.image = UIImage(named: "ksv.png")
        case "KT": cell.img_rightTeam.image = UIImage(named: "kt.png")
        case "Rox": cell.img_rightTeam.image = UIImage(named: "rox.png")
        case "KZ": cell.img_rightTeam.image = UIImage(named: "kz.png")
        default: cell.img_rightTeam.image = UIImage(named: "skt.png")
        }
        
        //ticketing
        cell.btn_ticketAlarm.tag = (data?.id)!
        cell.btn_ticketAlarm.addTarget(self, action: #selector(ticketBtnSelected), for: .touchUpInside)
        
        //start
        cell.btn_startAlarm.tag = (data?.id)!
        cell.btn_startAlarm.addTarget(self, action: #selector(startBtnSelected), for: .touchUpInside)
        
        return cell
    }
    
    //날짜 설정하기
    func setCalendarData(_ year: Int, _ month: Int, _ day: Int, _ hh: Int, _ mm: Int, _ ss: Int) -> Date {
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var components = DateComponents()
        components.setValue(year, for: Calendar.Component.year)
        components.setValue(month, for: Calendar.Component.month)
        components.setValue(day, for: Calendar.Component.day)
        
        //시간은 나중에 변경하기
        components.setValue(Int(hh), for: Calendar.Component.hour)
        components.setValue(mm, for: Calendar.Component.minute)
        components.setValue(ss, for: Calendar.Component.second)
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        print("설정된 날짜는\(calendar.date(from: components)!)")
        return calendar.date(from: components)!
    }
    
    //티켓팅 알림 button
    @objc func ticketBtnSelected(sender: UIButton) {
        let ticketingdate = items?.filter("id == %@",sender.tag)[0].ticketdate
        
        let mTitle = items?.filter("id == %@",sender.tag)[0].matchtitle
        let tmp: String? = String(describing: ticketingdate)
        var ticketingTime = tmp?.components(separatedBy: ["-"," ",":"])
        for i in ticketingTime! {
            print(i)
        }
        
        //local notification
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification(Int(ticketingTime![3])!, Int(ticketingTime![4])!, String(describing: mTitle!), "티켓팅")
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification(Int(ticketingTime![3])!, Int(ticketingTime![4])!, String(describing: mTitle!), "티켓팅")
                break
            case .denied:
                //여기 alert로 알려주도록 하기
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    private func scheduleLocalNotification(_ hh: Int, _ mm: Int, _ title: String, _ type: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        
        switch type {
        case "경기":
            notificationContent.title = "경기 알람"
            notificationContent.body = "오늘 \(hh)시에 \(title)의 \(type)가 있습니다."
        case "티켓팅":
            notificationContent.title = "티켓팅 알람"
            notificationContent.body = "오늘 \(hh)시 \(mm)분에 \(title)의 \(type)이 있습니다."
        default:
            notificationContent.body = "error"
        }
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    //경기 시작 알림 button
    @objc func startBtnSelected(sender: UIButton) {
        let query = items?.filter("id == %@",sender.tag)[0]
        let matchdate = query?.matchdate
        
        let mTitle = query?.matchtitle
        let tmp: String? = String(describing: matchdate)
        var matchstart = tmp?.components(separatedBy: ["-"," ",":"])
        
        //local notification
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification(Int(matchstart![3])!, Int(matchstart![4])!, String(describing: mTitle!), "경기")
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification(Int(matchstart![3])!, Int(matchstart![4])!,String(describing: mTitle!), "경기")
                break
            case .denied:
                //여기 alert로 알려주도록 하기
                print("Application Not Allowed to Display Notifications")
            }
        }
        
    }
    
    //CALENDAR PART
    //날짜 클릭시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    //subtitle
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        //eventdates는 matchdate가 모여있는 array임.
        for eventDate in eventdates {
            if self.gregorian.isDate(date, inSameDayAs: eventDate){
                return "경기날"
            }
            if self.gregorian.isDateInToday(date){
                return "today"
            }
        }
        return nil
        
    }
    
    //event dots
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        dateFormatter.dateFormat = "MM월 dd일"
        let mmdd = dateFormatter.string(from: date)
        
        //eventdates는 matchdate가 모여있는 array임.
        for eventDate in eventdates {
            if self.gregorian.isDate(date, inSameDayAs: eventDate){
                let stadium = items?.filter("mmdd_date == %@",mmdd)[0].stadium
                
                //이벤트 마다 색깔 바뀌도록 변경할 것.
                switch stadium {
                case "상암":
                    calendar.appearance.eventDefaultColor = UIColor.green
                case "강남":
                    calendar.appearance.eventDefaultColor = UIColor.blue
                default:
                    calendar.appearance.eventDefaultColor = UIColor.orange
                }
                return 1
            }
        }
        return 0
    }
}
extension ScheduleViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

