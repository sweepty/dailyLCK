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
import UserNotifications
import RxSwift
import RxCocoa
import RxDataSources

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    private var formatter = DateFormatter()
    private let request = Requests()
    
    // 경기 정보 담을 객체
    public var matchList = [Matches]()
    
    let calendarViewModel = CalendarViewModel()
    
    var disposeBag = DisposeBag()
    
    // 설정되어 있는 알림 확인
    var notifications: [String] = []
    
    let numOfRowsInCalendar = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 설정된 알림 리스트
        checkNotifications()
        
        // 테이블 뷰 설정
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let nibName = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "detailCell")
        
        setupBind()
        
        // 현재 날짜로 스크롤
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        
        setupCalendarView()
        if self.matchList.count == 0 {
            spinner.startAnimating()
            
            requestMatches()
        }
    }
    
    private func setupBind() {
        // RxDataSources
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, match in
                let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell

                cell.blueLogoImageView.image = UIImage(named: "\(match.blue)")
                cell.redLogoImageView.image = UIImage(named: "\(match.red)")
                cell.blueLabel.text = match.blue
                cell.redLabel.text = match.red
                
                // 몽고디비의 타임존이 UTC로 고정되어 있기 때문에 9시간을 더해줌.
                let timeInfo = match.mDate.toCorrectTime()
                
                self.formatter.dateFormat = "ha" // am pm
                self.formatter.locale = Locale(identifier: "en_US")
                self.formatter.timeZone = Calendar.current.timeZone
                
                let startingTime: String = self.formatter.string(from: timeInfo)
                cell.timeLabel.text = startingTime
                
                // 경기 날짜가 현재 시간보다 이전이면 버튼 안보이게 테스트 중이라 잠시 주석 처리
//                guard self.matchList[self.matchListFlag ?? 0 + indexPath.row].mDate >= Date() else {
//                    cell.alarmButton.isHidden = true
//                    return cell
//                }
                
                // 버튼 이미지 설정
                self.setBtnImage(timeInfo, cell)
                
                cell.alarmButton.rx.tap
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (_) in
                        let center = UNUserNotificationCenter.current()
                        
                        let selectedDate: Date = dataSource[indexPath.section].items[indexPath.row].mDate
                        let changeLocal = selectedDate.toCorrectTime()
                        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                        let hour = self.formatter.string(from: changeLocal)
                        
                        var nextTrigger = String()
                        
                        let semaphore = DispatchSemaphore(value: 0)
                        
                        center.getPendingNotificationRequests { (notifiations) in
                            for noti in notifiations {
                                // 알람이 설정되어 있는 경우
                                if noti.identifier == hour {
                                    nextTrigger = noti.identifier
                                    break
                                }
                            }
                            semaphore.signal()
                        }
                        semaphore.wait()
                        
                        if nextTrigger.isEmpty {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Alarm") as! AlarmViewController
                            nextVC.modalTransitionStyle = .crossDissolve
                            nextVC.modalPresentationStyle = .overCurrentContext
                            nextVC.match = match
                            self.present(nextVC, animated: true, completion: nil)
                            
                        } else {
                            let alertController = UIAlertController()
                            alertController.title = "알림 삭제"
                            alertController.message = "이미 경기 0분 전으로 알람이 설정되어있습니다.\n삭제하시겠습니까?"
                            
                            let deleteAlarmAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                                Log.info("삭제합니다")
                                center.removePendingNotificationRequests(withIdentifiers: ["\(nextTrigger)"])
                            })
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                            
                            alertController.addAction(deleteAlarmAction)
                            alertController.addAction(cancelAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }).disposed(by: cell.cellBag)
                
                return cell
        })
        
        // tableview bind
        calendarViewModel.detail
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀 선택시
        tableView.rx.modelSelected(Matches.self)
            .subscribe(onNext: { (matches) in
                let storyboard: UIStoryboard = UIStoryboard(name: "DetailView", bundle: nil)
                let nextView = storyboard.instantiateInitialViewController()
                let vc = nextView as? DetailViewController
                vc?.info = matches
                self.navigationController?.pushViewController(vc!, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupCalendarView() {
        // Set up labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        // 오늘 날짜 선택하고 테이블뷰에도 보여주기
        self.calendarView.selectDates([Date()])
        
        calendarView.minimumLineSpacing = 1
        calendarView.minimumInteritemSpacing = 0
        calendarView.cellSize = calendarView.frame.size.width / 7
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else {
            return
        }
        self.formatter.dateFormat = "MMMM"
        let month = self.formatter.string(from: date)
        
        self.monthLabel.rx.text.onNext(month)
        
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let myCell = cell as? CellView else { return }
        
        handleCellTextColor(cell: myCell, cellState: cellState)
        handleCellVisiblity(cell: myCell, cellState: cellState)
        handleCellSelection(cell: myCell, cellState: cellState)
        
    }
    
    func handleCellTextColor(cell: CellView, cellState: CellState) {
        let todaysDate = Date()
        
        self.formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = self.formatter.string(from: todaysDate)
        let monthsDateString = self.formatter.string(from: cellState.date)
        
        // 오늘 날짜에 색깔 넣기
        if todaysDateString == monthsDateString {
            cell.dayLabel.textColor = UIColor.red
        } else {
            cell.dayLabel.textColor = UIColor.black
        }
    }
    
    func handleCellVisiblity(cell: CellView, cellState: CellState) {
        // 이번달 날짜가 아니면 안보이게 한다.
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        cell.isHidden = cellHidden
    }
    
    func handleCellSelection(cell: CellView, cellState: CellState) {
        cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    func requestMatches() {
        request.getMatchInfo { (matches) in
            guard let matches = matches else {
                let alert = UIAlertController(title: "네트워크 오류", message: "네트워크 연결상태를 확인해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            self.matchList = matches
            // 시간 정렬
            self.matchList.sort { $0.mDate < $1.mDate }
            
            // 오늘의 경기를 찾아서 테이블뷰에 넣습니다.
            self.calendarViewModel.detail.onNext([SectionOfCustomData(items: self.todaysMatch(selectedDate: Date()))])
            
            // update UI
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
            self.spinner.stopAnimating()
        }
    }
    
    // 선택한 날짜의 경기 찾기 (처음에는 오늘의 경기를 찾고 다음에는 선택한 날짜의 경기를 찾는데 재사용합니다.)
    func todaysMatch(selectedDate: Date) -> [Matches] {
        // 셀에 해당하는 데이터 넣기
        var todaysMatches = [Matches]()
        
        for i in self.matchList {
            if Calendar.current.isDate(i.mDate, inSameDayAs: selectedDate) == true {
                todaysMatches.append(i)
            }
        }
        return todaysMatches
    }
    
    func checkNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                self.notifications.append(request.identifier)
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy MM dd"
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Locale(identifier: "en_US")
        
        let startDate = self.formatter.date(from: "2019 01 01")!
        let endDate = self.formatter.date(from: "2020 12 30")!
        
        // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .off,
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
        
        // 스택 뷰 라벨 간격
        dateCell.listStackView.spacing = 0.5
        
        dateCell.dayLabel.text = cellState.text
        
        for (_, element) in self.matchList.enumerated() {
            let eDate = element.mDate.toCorrectTime()
            if Calendar.current.isDate(eDate, inSameDayAs: date) == true {
                let textLabel = UILabel()
                textLabel.adjustsFontSizeToFitWidth = true
                textLabel.backgroundColor = UIColor.lightGray
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel.text = "\(element.blue) : \(element.red)"
                textLabel.font = textLabel.font.withSize(9)
                textLabel.textColor = UIColor.black
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
        
        // 스크롤 하면 다음달 1일을 선택한 셀로 만들기
        if let firstDate = visibleDates.monthDates.first?.date {
            self.calendarView.selectDates([firstDate])
        }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CellView else { return }
        
        validCell.selectedView.isHidden = false
        self.tableView.isHidden = false
        
        let selectedDate = cellState.date
        
        self.calendarViewModel.detail.onNext([SectionOfCustomData(items: todaysMatch(selectedDate: selectedDate))])
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CellView else { return }
        
        validCell.selectedView.isHidden = true
        self.tableView.isHidden = true
        
    }
    
    func setBtnImage(_ timeInfo: Date, _ cell: DetailTableViewCell) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                let date = self.formatter.string(from: timeInfo)
                if request.identifier == date {
                    DispatchQueue.main.async {
                        cell.alarmButton.setImage(UIImage(named: "alarm_activate"), for: UIControl.State.normal)
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.alarmButton.setImage(UIImage(named: "alarm_nonactivate"), for: UIControl.State.normal)
                    }
                }
            }
        }
    }
}

extension CalendarViewController: UITableViewDelegate {
    // 셀 선택시 해제
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//extension CalendarViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        self.adjustCalendarViewHeight()
//        if self.detailList.count == 0 {
//            let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//            let messageLabel = UILabel(frame: rect)
//            messageLabel.text = "이 날은 열리는 경기가 없어요 🏆"
//            messageLabel.textColor = UIColor.black
//            messageLabel.numberOfLines = 0;
//            messageLabel.textAlignment = .center;
//            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//            messageLabel.sizeToFit()
//
//            tableView.backgroundView = messageLabel;
//            tableView.separatorStyle = .none;
//        } else {
//            tableView.backgroundView = nil
//            tableView.separatorStyle = .singleLine
//        }
//        return self.detailList.count
//    }
    // 시간 계산
    func calculateTimeInterval(startDate: Date, endDate: Date) -> TimeInterval {
        let interval = endDate.timeIntervalSince(startDate)
        return interval
    }
// }


extension CalendarViewController: UNUserNotificationCenterDelegate {
    // foreground에 있을 때에도 알림이 오게 함
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // 처음에 알림 권한 허락 받을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
        
    }
    
}

