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
import FSCalendar
import UserNotifications
import FirebaseDatabase
import SnapKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendarView: FSCalendar!


    
    //realm
    let realm = try! Realm()
    var items: Results<Match>?
    
    //tableview section name List
    var matchup_dates : [String] = []
    var list :[String:[Int]] = [:]
    
    // 월별 몇개 있는지. dictionary
    var months: [String: Int] = [:]
    var sortedList :[Date] = []
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    //dateformatter(date to string, string to date)
    let dateFormatter = DateFormatter()
    
    //현재 날짜 시간
    let date = NSDate()
    
    //event dot 뿌려주기
    var eventdates : [Date] = []
    
    var isMonthMode = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        grabData()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 70.0
        
        // calendar 설정
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.clipsToBounds = true
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
//        calendarView.appearance.weekdayFont = UIFont (name: "HelveticaNeue", size: 20)
        calendarView.appearance.titleFont = UIFont (name: "HelveticaNeue", size: 17)
        calendarView.appearance.headerTitleColor = UIColor.black
//        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        // Realm 저장 위치 보여줌
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        items = realm.objects(Match.self)
        
        // 날짜로 sort
        items = items?.sorted(byKeyPath: "date", ascending: true)
        
        if let mItems = items {
            for i in mItems {
                dateFormatter.dateFormat = "YYYY년 M월"
                let d = dateFormatter.string(from: i.date)
                if months.keys.contains(d) {
                    months.updateValue(months[d]! + 1, forKey: d)
                } else {
                    months[d] = 1
                    
                    //섹션 명
                    matchup_dates.append(d)
                    
                    
                }
            }
        }
        
        //날짜 순으로 정렬.
        matchup_dates.sort()
        
        //local notification
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
    }
    
    func grabData() {
        let databaseRef = Database.database().reference()
        databaseRef.child("match").observe(.value, with: {
            (snapshot) in
            print(snapshot)
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                guard var dictionary = snap.value as? [String : AnyObject] else {
                    return
                }
                let id = Int(snap.key)
//                let mTitle = dictionary["title"] as? String
            
                //date format 해줘야함...
                let mDate = dictionary["date"] as? String
                self.dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                self.dateFormatter.locale = Locale(identifier:"ko_KR")
                let matchDate = self.dateFormatter.date(from: mDate!)
                
                //date format 해줘야함...
                let tDate = dictionary["ticketDate"] as? String
                self.dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                self.dateFormatter.locale = Locale(identifier:"ko_KR")
                let ticketDay = self.dateFormatter.date(from: tDate!)
                let teamLeft = dictionary["teamLeft"] as? String
                let teamRight = dictionary["teamRight"] as? String
                let stadium = dictionary["stadium"] as? String

                let matchToAdd = Match()
                matchToAdd.id = id!
                matchToAdd.date = matchDate!
                matchToAdd.ticketDate = ticketDay!
                matchToAdd.teamLeft = teamLeft!
                matchToAdd.teamRight = teamRight!
                matchToAdd.stadium = stadium!
//                matchToAdd.season = season!
//                matchToAdd.round = round!
//                matchToAdd.mmdd_date = mmdd_date!
                
                matchToAdd.writeToRealm()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //테이블 섹션 명
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(matchup_dates[section])"
    }
    
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchup_dates.count
    }
    
    //각 섹션 당 셀 수 얻기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monthsKeys = months.keys.sorted()
        return (months[monthsKeys[section]])!

    }
    
    
    //요일 만들기
    func getDayOfWeek(today:Date)->String {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: today)
        let weekDay = myComponents.weekday

        switch weekDay {
        case 1: return "일요일"
        case 2: return "월요일"
        case 3: return "화요일"
        case 4: return "수요일"
        case 5: return "목요일"
        case 6: return "금요일"
        default: return "토요일"
        }
    }
    
    
    // 셀 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
        let data = items![indexPath.row]
        dateFormatter.dateFormat = "hh:mm"
        let startTime = dateFormatter.string(from:(data.date))

        //MM으로 할지 경기장으로 할지? 우선 경기장으로
//        cell.monthLabel.text = data.stadium
        dateFormatter.dateFormat = "dd"
        let dayday = dateFormatter.string(from: (data.date as Date?)!)
        cell.dayLabel.text = dayday
        cell.weekLabel.text = getDayOfWeek(today: (data.date))
        cell.timeLabel.text = "PM \(startTime)"
        cell.leftTeamLabel.text = data.teamLeft
        cell.rightTeamLabel.text = data.teamRight
        
        switch data.stadium {
        case "OGN":
            cell.barView.backgroundColor = UIColor.green
        case "SPOTV":
            cell.barView.backgroundColor = UIColor.blue
        default:
           cell.barView.backgroundColor = UIColor.orange
        }
        
        // 왼쪽 팀 image
        switch data.teamLeft {
        case "SKT": cell.img_leftTeam.image = UIImage(named: "skt.png")
        case "Afreeca": cell.img_leftTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_leftTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_leftTeam.image = UIImage(named: "jag.png")
        case "Gen.G": cell.img_leftTeam.image = UIImage(named: "gen.png")
        case "KT": cell.img_leftTeam.image = UIImage(named: "kt.png")
        case "HLE": cell.img_leftTeam.image = UIImage(named: "hie.png")
        case "KING-ZONE": cell.img_leftTeam.image = UIImage(named: "kz.png")
        case "Griffin": cell.img_leftTeam.image = UIImage(named: "griffin.png")
        case "MVP": cell.img_leftTeam.image = UIImage(named: "mvp.png")
        default: cell.img_leftTeam.image = UIImage(named: "skt.png") // 다른 이미지로 교체 할것
        }
        
        //오른쪽 팀 image
        switch data.teamRight {
        case "SKT": cell.img_rightTeam.image = UIImage(named: "skt.png")
        case "Afreeca": cell.img_rightTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_rightTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_rightTeam.image = UIImage(named: "jag.png")
        case "Gen.G": cell.img_rightTeam.image = UIImage(named: "gen.png")
        case "KT": cell.img_rightTeam.image = UIImage(named: "kt.png")
        case "HLE": cell.img_rightTeam.image = UIImage(named: "hie.png")
        case "KING-ZONE": cell.img_rightTeam.image = UIImage(named: "kz.png")
        case "Griffin": cell.img_rightTeam.image = UIImage(named: "griffin.png")
        case "MVP": cell.img_rightTeam.image = UIImage(named: "mvp.png")
        default: cell.img_rightTeam.image = UIImage(named: "skt.png") // 다른 이미지로 교체 할것
        }
        
        //ticketing
        cell.btn_ticketAlarm.tag = (data.id)
        cell.btn_ticketAlarm.addTarget(self, action: #selector(ticketBtnSelected), for: .touchUpInside)
        
        //start
        cell.btn_startAlarm.tag = (data.id)
        cell.btn_startAlarm.addTarget(self, action: #selector(startBtnSelected), for: .touchUpInside)
        
        return cell
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //오늘날짜가 가장 처음으로 나오도록?
//
//        tableView.scrollToRow(at: IndexPath(row: 1, section: 3), at: .none , animated: false)
//    }
    
    // cell 선택 시 해당 셀로 스크롤
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
    func notificating(_ hh: Int, _ mm: Int, _ title:String, _ type: String){
        //local notification
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Request Authorization
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification(hh, mm, title, type)
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification(hh, mm, title, type)
                
            case .denied:
                //여기 alert로 알려주도록 하기 (예정)
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    
    //티켓팅 알림 button
    @objc func ticketBtnSelected(sender: UIButton) {
        let query = items?.filter("id == %@",sender.tag)[0]
        
        let ticketingdate = query?.ticketDate
        let mTitle = query?.title
        let tmp = String(describing: ticketingdate)
        var ticketingTime = tmp.components(separatedBy: ["-"," ",":"])
        notificating(Int(ticketingTime[3])!, Int(ticketingTime[4])!,String(describing: mTitle!), "티켓팅")
        
    }
    
    
    //경기 시작 알림 button
    @objc func startBtnSelected(sender: UIButton) {
        let query = items?.filter("id == %@",sender.tag)[0]
        
        let matchdate = query?.date
        let mTitle = query?.title
        let tmp = String(describing: matchdate)
        var matchstart = tmp.components(separatedBy: ["-"," ",":"])
        notificating(Int(matchstart[3])!, Int(matchstart[4])!,String(describing: mTitle!), "경기")
        
    }
    
    private func scheduleLocalNotification(_ hh: Int, _ mm: Int, _ title: String, _ type: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        switch type {
        case "경기" where mm == 0:
            notificationContent.title = "경기 알람"
            notificationContent.body = "오늘 \(hh)시에 \(title)의 \(type)가 있습니다."
        //경기는 항상 정시에 시작하지만 혹시 모르니까 추가
        case "경기" where mm != 0:
            notificationContent.title = "경기 알람"
            notificationContent.body = "오늘 \(hh)시 \(mm)분에 \(title)의 \(type)가 있습니다."
        case "티켓팅" where mm == 0:
            notificationContent.title = "티켓팅 알람"
            notificationContent.body = "오늘 \(hh)시에 \(title)의 \(type)이 있습니다."
        case "티켓팅" where mm != 0:
            notificationContent.title = "티켓팅 알람"
            notificationContent.body = "오늘 \(hh)시 \(mm)분에 \(title)의 \(type)이 있습니다."
        default:
            notificationContent.body = "error"
        }

//        var dateComponents = DateComponents()
//        dateComponents.weekday = 2
//        dateComponents.month = 4
//        dateComponents.day = 16
//        dateComponents.hour = 3
//        dateComponents.minute = 20
        
        //시간 바꾸기 (예정)
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
//        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
        
        
        // Create Notification Request
        let id: String?
        switch type {
        case "경기": id = "match"
        case "티켓팅": id = "ticketing"
        default: id = "default"
        }
        
        let notificationRequest = UNNotificationRequest(identifier: id!, content: notificationContent, trigger: notificationTrigger)
        
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
    
    
    
    //CALENDAR PART
    
    //날짜 클릭시 해당하는 섹션으로 이동 (수정필요)
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = dateFormatter.string(from: date as Date)
        if matchup_dates.contains(selectedDate) {
            let idx = matchup_dates.index(of: selectedDate)
            let indexPath = NSIndexPath(item: 0, section: idx!)
            tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
//    //event dots
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        dateFormatter.dateFormat = "MM월 dd일"
//        let mmdd = dateFormatter.string(from: date)
//
//        //eventdates는 matchdate가 모여있는 array임.
//        for eventDate in eventdates {
//            if self.gregorian.isDate(date, inSameDayAs: eventDate){
//                //이미 지난 경기이면 eventdot 색깔 바꿔주도록 하기 (예정)
//
//                let stadium = items?.filter("mmdd_date == %@",mmdd)[0].stadium
//
//                //이벤트 마다 색깔 바뀌도록 변경할 것. (예정)
//                switch stadium {
//                case "OGN":
//                    calendar.appearance.eventSelectionColor = UIColor.green
//                case "SPOTV":
//                    calendar.appearance.eventSelectionColor = UIColor.blue
//                default:
//                    calendar.appearance.eventSelectionColor = UIColor.orange
//                }
//                return 1
//            }
//        }
//        return 0
//    }
    
    // 달이 바뀌었을 때.
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        // Do something
    }
}
extension ScheduleViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

