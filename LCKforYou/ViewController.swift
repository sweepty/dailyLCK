//
//  ViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 7..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//
import UIKit
import FSCalendar
import Toaster
import Realm
import RealmSwift

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var calendarTableView: UITableView!
    fileprivate let gregorian = Calendar(identifier: .gregorian)

    var matchup: Results<match>?
    var number: Int?
    //event dot 뿌려주기
    var eventdates : [Date] = []

    let dateFormatter = DateFormatter()
    //date formatter
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 10, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        calendar.scrollDirection = .vertical
        calendar.clipsToBounds = true
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.eventDefaultColor = UIColor.purple
        
        //realm
        // Get the default Realm
        let realm = try! Realm()
        matchup = realm.objects(match.self)
        number = matchup?.count
        print("개수는\(String(describing: number))")
        
        //날짜 받아서 eventdots로 뿌려주기 위함.
        for event in matchup! {
            eventdates.append(event.matchdate)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (matchup?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
        let item = matchup![indexPath.row]
        //date to string
        //        let date = NSDate()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm:ss"
//        let dateString = dateFormatter.string(from: item.matchdate as Date)
//        print(dateString)
        
//        cell.TitleLabel.text = item.matchtitle
//        cell.dateLabel.text = dateString
        print("왜 안돼")
        cell.TitleLabel.text = "good"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        formatter.dateFormat = "yyyy/MM/dd"
        
        //eventdates는 matchdate가 모여있는 array임.
        for eventDate in eventdates {
            if self.gregorian.isDate(date, inSameDayAs: eventDate){
                return 2
            }
        }
        return 0
    }
    
}

