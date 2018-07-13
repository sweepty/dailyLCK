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
        
        self.tableView.rowHeight = 90.0
        
    
        // calendar 설정
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.clipsToBounds = true
        calendarView.appearance.headerDateFormat = "MMMM"
//        calendarView.appearance.header
        calendarView.appearance.headerTitleColor = UIColor.black
//        calendarView.clipsToBounds = true
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        // Realm 저장 위치 보여줌
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        items = realm.objects(Match.self)
        
        
        for i in items! {
            //calendar용
            //날짜 받아서 eventdots로 뿌려주기 위함.
            eventdates.append(i.date)
            
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
                let mTitle = dictionary["title"] as? String
            
                //date format 해줘야함...
                let mDate = dictionary["date"] as? String
                self.dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                let matchDate = self.dateFormatter.date(from: mDate!)
                
                //date format 해줘야함...
                let tDate = dictionary["ticketDate"] as? String
                self.dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                let ticketDay = self.dateFormatter.date(from: tDate!)
                let teamLeft = dictionary["teamLeft"] as? String
                let teamRight = dictionary["teamRight"] as? String
                let stadium = dictionary["stadium"] as? String
                let season = dictionary["season"] as? String
                let round = dictionary["round"] as? String
                let mmdd_date = dictionary["mmdd_date"]  as? String
                
                let matchToAdd = Match()
                matchToAdd.id = id!
                matchToAdd.title = mTitle!
                matchToAdd.date = matchDate!
                matchToAdd.ticketDate = ticketDay!
                matchToAdd.teamLeft = teamLeft!
                matchToAdd.teamRight = teamRight!
                matchToAdd.stadium = stadium!
                matchToAdd.season = season!
                matchToAdd.round = round!
                matchToAdd.mmdd_date = mmdd_date!
                
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
        return (items?.filter("mmdd_date ==%@",matchup_dates[section]).count)!
    }
    
    
    //요일 만들기
    func getDayOfWeek(today:Date)->String {
        dateFormatter.locale = Locale(identifier:"ko_KR")
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
        
        
        //items
        let data = items?.filter("mmdd_date == %@",matchup_dates[indexPath.section])[indexPath.row]
        dateFormatter.dateFormat = "hh:mm"
        let startTime = dateFormatter.string(from:(data?.date)!)
        
        //MM으로 할지 경기장으로 할지? 우선 경기장으로
        cell.monthLabel.text = data?.stadium
        dateFormatter.dateFormat = "dd"
        let dayday = dateFormatter.string(from: (data?.date as Date?)!)
//        cell.dayLabel.text = dayday
//        cell.weekLabel.text = getDayOfWeek(today: (data?.date)!)
        cell.timeLabel.text = "PM \(startTime)"
        cell.leftTeamLabel.text = data?.teamLeft
        cell.rightTeamLabel.text = data?.teamRight
        
        switch data?.stadium {
        case "ogn":
            cell.barView.backgroundColor = UIColor.green
        case "spotv":
            cell.barView.backgroundColor = UIColor.blue
        default:
           cell.barView.backgroundColor = UIColor.orange
        }
        // image db에 넣는 방향으로 수정하자
        // 왼쪽 팀 image
        switch data?.teamLeft {
        case "SKT": cell.img_leftTeam.image = UIImage(named: "skt.png")
        case "AFs": cell.img_leftTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_leftTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_leftTeam.image = UIImage(named: "jag.png")
        case "KSV": cell.img_leftTeam.image = UIImage(named: "ksv.png")
        case "KT": cell.img_leftTeam.image = UIImage(named: "kt.png")
        case "HIE": cell.img_leftTeam.image = UIImage(named: "hie.png")
        case "KZ": cell.img_leftTeam.image = UIImage(named: "kz.png")
        case "FIN": cell.img_leftTeam.image = UIImage(named: "griffin.png")
        case "MVP": cell.img_leftTeam.image = UIImage(named: "kz.png") //임시
        default: cell.img_leftTeam.image = UIImage(named: "skt.png")
        }
        
        //오른쪽 팀 image
        switch data?.teamRight {
        case "SKT": cell.img_rightTeam.image = UIImage(named: "skt.png")
        case "AFs": cell.img_rightTeam.image = UIImage(named: "afs.png")
        case "bbq": cell.img_rightTeam.image = UIImage(named: "bbq.png")
        case "Jin Air": cell.img_rightTeam.image = UIImage(named: "jag.png")
        case "KSV": cell.img_rightTeam.image = UIImage(named: "ksv.png")
        case "KT": cell.img_rightTeam.image = UIImage(named: "kt.png")
        case "HIE": cell.img_rightTeam.image = UIImage(named: "hie.png")
        case "KZ": cell.img_rightTeam.image = UIImage(named: "kz.png")
        case "FIN": cell.img_rightTeam.image = UIImage(named: "griffin.png")
        case "MVP": cell.img_rightTeam.image = UIImage(named: "kz.png")
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
    
    // cell 선택 시
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
    
    //subtitle
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //eventdates는 matchdate(Date)가 모여있는 array임.
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
                //이미 지난 경기이면 eventdot 색깔 바꿔주도록 하기 (예정)
        
                let stadium = items?.filter("mmdd_date == %@",mmdd)[0].stadium
                
                //이벤트 마다 색깔 바뀌도록 변경할 것. (예정)
                switch stadium {
                case "상암":
                    calendar.appearance.eventSelectionColor = UIColor.green
                case "강남":
                    calendar.appearance.eventSelectionColor = UIColor.blue
                default:
                    calendar.appearance.eventSelectionColor = UIColor.orange
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

