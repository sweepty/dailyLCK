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

class CalendarViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let dateCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CellView
        
        dateCell.dayLabel.text = cellState.text
        
        
        if cellState.dateBelongsTo == .thisMonth {
            dateCell.dayLabel.textColor = UIColor.black
        } else {
            dateCell.dayLabel.textColor = UIColor.gray
        }
        return dateCell
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2030 12 30")!
        // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
}
