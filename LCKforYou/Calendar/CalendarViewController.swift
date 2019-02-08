//
//  CalendarViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 25/11/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import Foundation
import JTAppleCalendar
import Realm
import RealmSwift
import Alamofire

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    
    // 경기 정보 담을 객체
    public static var matchList = [Matches]()
    
    // 테이블뷰 정보
    static var detailList = [Matches]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 설정
        
        let nibName = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "detailCell")
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        self.tableView.isHidden = true
        
        
        // 현재 날짜로 스크롤
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        
        setupCalendarView()
        
        if CalendarViewController.matchList.count == 0 {
            requestMatches()
        }
    }
    
    func setupCalendarView() {
        // Set up labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.minimumLineSpacing = 1
        calendarView.minimumInteritemSpacing = 0
        calendarView.cellSize = calendarView.frame.size.width / 7
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date!)
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date!)
        
        
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let myCell = cell as? CellView else { return }
        
        handleCellTextColor(cell: myCell, cellState: cellState)
        handleCellVisiblity(cell: myCell, cellState: cellState)
        handleCellSelection(cell: myCell, cellState: cellState)
        
    }
    
    func handleCellTextColor(cell: CellView, cellState: CellState) {
        let todaysDate = Date()

        formatter.dateFormat = "yyyy MM dd"

        let todaysDateString = formatter.string(from: todaysDate)
        let monthsDateString = formatter.string(from: cellState.date)
        
        // 오늘 날짜에 색깔 넣기
        if todaysDateString == monthsDateString {
            cell.dayLabel.textColor = UIColor.red
        } else {
            cell.dayLabel.textColor = UIColor.black
        }
    }
    
    func handleCellVisiblity(cell: CellView, cellState: CellState) {
//        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
        cell.dayLabel.textColor = cellState.dateBelongsTo == .thisMonth ? UIColor.black : UIColor.lightGray
    }
    
    func handleCellSelection(cell: CellView, cellState: CellState) {
        cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    func requestMatches() {
        Requests().getMatchInfo() { (isSuccess, matches)  in
            print("이게 머야 \(isSuccess)")
            if isSuccess {
                // 시간 정렬
                CalendarViewController.matchList.sort { $0.mDate < $1.mDate }
                // update UI
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }
                
                print(CalendarViewController.matchList.count)
                print("개")
            } else {
                let alert = UIAlertController(title: "네트워크 오류", message: "네트워크 연결상태를 확인해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US")
        
        let startDate = formatter.date(from: "2019 01 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2020 12 30")!
        // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths, // forFirstMonthOnly forAllMonths
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .monday)
        
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let dateCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CellView
        configureCell(cell: dateCell, cellState: cellState)
        
        dateCell.dayLabel.text = cellState.text
        
        for (_, element) in CalendarViewController.matchList.enumerated() {
            // 몽고디비 때문에 9시간 더해준다.
            let eDate = element.mDate.addingTimeInterval(60.0 * 60 * 9)
            if Calendar.current.isDate(eDate, inSameDayAs: date) == true {
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.darkGray
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 23.0).isActive = true
                textLabel.text = "\(element.blue) : \(element.red)"
                textLabel.font = textLabel.font.withSize(9)
                textLabel.textColor = UIColor.white
                textLabel.textAlignment = .center
                textLabel.clipsToBounds = true
                textLabel.layer.cornerRadius = 3
                dateCell.listStackView.addArrangedSubview(textLabel)
            }
        }
        return dateCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarView()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CellView else { return }
        
        validCell.selectedView.isHidden = false
        self.tableView.isHidden = false
        
        let selectedDate = cellState.date
        
        // 새로 넣기 전에 기존 데이터 모두 지우기
        CalendarViewController.detailList.removeAll()
        
        // 셀에 해당하는 데이터 넣기
        for i in CalendarViewController.matchList {
            if Calendar.current.isDate(i.mDate, inSameDayAs: selectedDate) == true {
                CalendarViewController.detailList.append(i)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CellView else { return }
        
        validCell.selectedView.isHidden = true
        self.tableView.isHidden = true
        
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CalendarViewController.detailList.count == 0 {
            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = "이 날은 열리는 경기가 없어요😢"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = .none;
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return CalendarViewController.detailList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        
        let data = CalendarViewController.detailList[indexPath.row]
        cell.blueLogoImageView.image = UIImage(named: "\(data.blue)")
        cell.redLogoImageView.image = UIImage(named: "\(data.red)")
        
        cell.blueLabel.text = data.blue
        cell.redLabel.text = data.red
        
        // 몽고디비의 타임존이 UTC로 고정되어 있기 때문에 9시간을 더해줌.
        let timeInfo = data.mDate.addingTimeInterval(60.0 * 60.0 * 9.0)
        
        formatter.dateFormat = "ha" // am pm
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = Calendar.current.timeZone

        let startTime: String = formatter.string(from: timeInfo)

        
        cell.timeLabel.text = startTime
        return cell
    }
    
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = CalendarViewController.detailList[indexPath.row]
//        DetailViewController()
        
        let vcName = "DetailView"
        let vc = storyboard?.instantiateViewController(withIdentifier: vcName) as? DetailViewController
        vc?.info = data
        
        self.navigationController?.pushViewController(vc!, animated: true)
//        self.navigationController?.push
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
