//
//  DetailViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 08/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import UserNotifications
import RxSwift
import RxCocoa

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
    @IBOutlet weak var ticketAlarmButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
    }
    
    private func setupUI() {
        redImageView.image = UIImage(named: (info?.red)!)
        blueImageView.image = UIImage(named: (info?.blue)!)
        
        blueLabel.text = changeFullName(name: (info?.blue)!)
        redLabel.text = changeFullName(name: (info?.red)!)
        
        formatter.dateFormat = "yyyy년 M월 dd일 (EEE) a h:mm"
        formatter.locale = Locale.init(identifier: "ko_KR")
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
        
        if let matchInfo = self.info, matchInfo.tDate.toCorrectTime() < Date() {
            ticketAlarmButton.isHidden = true
        }
    }
    
    private func setupBind() {
        self.ticketAlarmButton.rx.tap
            .subscribe(onNext: { (_) in
                let center = UNUserNotificationCenter.current()
                
                guard let matchInfo = self.info else {
                    return
                }
                
                self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                var hour = self.formatter.string(from: matchInfo.mDate)
                hour.append("t")
                
                var nextTrigger = String()
                
                let semaphore = DispatchSemaphore(value: 0)
                
                center.getPendingNotificationRequests { (notifiations) in
                    for noti in notifiations {
                        // 알람이 설정되어 있는 경우
                        print("noti: \(noti.identifier)\nhour: \(hour)")
                        if noti.identifier.contains(hour) {
                            nextTrigger = noti.identifier
                            break
                        }
                    }
                    semaphore.signal()
                }
                semaphore.wait()
                
                if nextTrigger.isEmpty {
                    let nextVC = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "Alarm") as! AlarmViewController
                    nextVC.modalTransitionStyle = .crossDissolve
                    nextVC.modalPresentationStyle = .overCurrentContext
                    nextVC.match = matchInfo
                    nextVC.type = .ticket
                    self.present(nextVC, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController()
                    alertController.title = "알림 삭제"
                    let time: String = String(nextTrigger.split(separator: "|")[1])
                    
                    alertController.message = "이미 티켓팅 \(time)에 알람이 설정되어있습니다.\n삭제하시겠습니까?"
                    
                    let deleteAlarmAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (_) in
                        Log.info("삭제합니다")
                        center.removePendingNotificationRequests(withIdentifiers: ["\(nextTrigger)"])
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                    
                    alertController.addAction(deleteAlarmAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
    }

}
