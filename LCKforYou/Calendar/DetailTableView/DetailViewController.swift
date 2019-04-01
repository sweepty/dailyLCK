//
//  DetailViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 08/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import UserNotifications

class DetailViewController: UIViewController {
    
    var info: Matches?
    
    let formatter = DateFormatter()

    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var redImageView: UIImageView!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    
    @IBOutlet weak var ticketDateLabel: UILabel!
    
    @IBAction func ticketAlarmButton(_ sender: UIButton) {
        showTicketNotificationActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redImageView.image = UIImage(named: (info?.red)!)
        blueImageView.image = UIImage(named: (info?.blue)!)
        
        blueLabel.text = changeFullName(name: (info?.blue)!)
        redLabel.text = changeFullName(name: (info?.red)!)
        
        formatter.dateFormat = "yyyy년 M월 dd일 EEE a h:mm"
        formatter.locale = Calendar.current.locale
        
        let matchDateLocaltime = info?.mDate.toCorrectTime()
        let matchDate = formatter.string(from: matchDateLocaltime!)
        matchDateLabel.text = matchDate
        stadiumLabel.text = info?.stadium
        
        
        let ticketDateLocaltime = info?.tDate.toCorrectTime()
        let ticketDate = formatter.string(from: ticketDateLocaltime!)
        ticketDateLabel.text = ticketDate
        
        blueLabel.sizeToFit()
        redLabel.sizeToFit()
        stadiumLabel.sizeToFit()
        matchDateLabel.sizeToFit()
        ticketDateLabel.sizeToFit()
    }
    
    /// 티켓팅 알람을 등록한다.
    ///
    /// - Parameters:
    ///   - time: 사용자가 설정한 시간.
    func registerTicketing(time: Double) {
        guard let info = self.info else {
            return
        }
        let ticketInfo = NotificationInfo.init(blue: info.blue, red: info.red, date: info.tDate)
        addRequest(time, ticketInfo, .ticket)
    }
    
    func showTicketNotificationActionSheet() {
        //the confirm action taking the inputs
        let oclockAction = UIAlertAction(title: "정시", style: .default) { (_) in
            let time = TimeChoicer.M0.time
            self.registerTicketing(time: time)
        }
        
        let fiveAction = UIAlertAction(title: "5분 전", style: .default) { (_) in
            let time = TimeChoicer.M5.time
            self.registerTicketing(time: time)
        }
        
        let tenAction = UIAlertAction(title: "10분 전", style: .default) { (_) in
            let time = TimeChoicer.M10.time
            self.registerTicketing(time: time)
        }
        
        let twentyAction = UIAlertAction(title: "20분 전", style: .default) { (_) in
            let time = TimeChoicer.M20.time
            self.registerTicketing(time: time)
        }
        
        let thirtyAction = UIAlertAction(title: "30분 전", style: .default) { (_) in
            let time = TimeChoicer.M30.time
            self.registerTicketing(time: time)
        }
        
        let oneHourAction = UIAlertAction(title: "1시간 전", style: .default) { (_) in
            let time = TimeChoicer.H60.time
            self.registerTicketing(time: time)
        }
        
        // 알람이 설정되어 있는 경우 삭제하기
        let deleteAlarmAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
            let center = UNUserNotificationCenter.current()
            
            guard let selectedInfo = self.info?.tDate else {
                return
            }
            let changeLocal = selectedInfo.toCorrectTime()
            self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            let id = self.formatter.string(from: changeLocal)
            center.removePendingNotificationRequests(withIdentifiers: ["\(id)"])
//            DispatchQueue.main.async {
//                sender.setImage(UIImage(named: "alarm_nonactivate"), for: UIControl.State.normal)
//            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        guard let selectedCellDate = self.info?.tDate else {
            return
        }
        let changeLocal = selectedCellDate.toCorrectTime()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let hour = formatter.string(from: changeLocal)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            //Creating UIAlertController and
            //Setting title and message for the alert dialog
            let alertController = UIAlertController()
            
            var nextTriggerDates: [String] = []
            for request in requests {
                nextTriggerDates.append(request.identifier)
            }
            if nextTriggerDates.contains(hour) {
                alertController.title = "알림 삭제"
                alertController.message = "알림을 삭제하시겠습니까?"
                
                alertController.addAction(deleteAlarmAction)
                alertController.addAction(cancelAction)
            } else {
                alertController.title = "알림 설정"
                alertController.message = "언제 푸시알림을 드릴까요?"
                
                alertController.addAction(oclockAction)
                alertController.addAction(fiveAction)
                alertController.addAction(tenAction)
                alertController.addAction(twentyAction)
                alertController.addAction(thirtyAction)
                alertController.addAction(oneHourAction)
                alertController.addAction(cancelAction)
            }
            //finally presenting the dialog box
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
