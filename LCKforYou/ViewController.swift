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
    
    
//    var number : Int? = nil
    var matchup: Results<schedule>?
    var number: Int?
    
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
//        calendar.appearance.eventDefaultColor = UIColor(
        
//        //realm
//        // Get the default Realm
        let realm = try! Realm()
//        var matchup = realm.objects(schedule.self).filter("teamLeft = 'SKT'")
        matchup = realm.objects(schedule.self)
        number = matchup?.count
        print("개수는\(String(describing: number))")
//        for i in matchup! {
//            print(i.matchdate)
//        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (matchup?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TableViewCell
        let item = matchup![indexPath.row]
        //date to string
        //        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh:mm:ss"
//        let dateString = dateFormatter.string(from: item.matchdate as Date)
//        print(dateString)
        
//        cell.TitleLabel.text = item.matchtitle
//        cell.dateLabel.text = dateString
        cell.TitleLabel.text = "good"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        Toast(text: self.formatter.string(from: date)).show()
//        print("did select date \(self.formatter.string(from: date))")

    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
//        if self.gregorian.isDateInWeekend(date) {
//            return "주말"
//        } else if self.gregorian.isDateInToday(date){
//            return "오늘"
//        }
        return nil
        
    }
    
}

