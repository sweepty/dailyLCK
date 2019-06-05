//
//  UserNotification.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 25/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import Foundation
import UserNotifications

enum Type: String {
    case match = "경기"
    case ticket = "티켓팅"
}

extension Type {
    var emoji: String {
        switch self {
        case .match: return "🏆"
        case .ticket: return "🎟"
        }
    }
}

enum TimeChoicer: Double {
    case M0 = 0
    case M5 = 5
    case M10 = 10
    case M15 = 15
    case M20 = 20
    case M30 = 30
    case M60 = 60
    case M120 = 120
}

extension TimeChoicer {
    var time: Double {
        return self.rawValue * -60.0
    }
    var name: String {
        switch self {
        case .M0:
            return "정각"
        case .M5:
            return "5분 전"
        case .M10:
            return "10분 전"
        case .M15:
            return "15분 전"
        case .M20:
            return "20분 전"
        case .M30:
            return "30분 전"
        case .M60:
            return "1시간 전"
        case .M120:
            return "2시간 전"
        }
    }
}

private let notiFormatter = DateFormatter()

// notification 등록
func registerNotification(time: Int, match: Matches, type: Type) -> Void {
    var notiDate = Date()

    switch type {
    case .match:
        notiDate = match.mDate
    case .ticket:
        notiDate = match.tDate
    }
    
    // 노티 객체
    let info: NotificationInfo = NotificationInfo.init(blue: match.blue, red: match.red, date: notiDate)
    
    notiFormatter.dateFormat = "a h:mm"
    notiFormatter.timeZone = TimeZone(identifier: "ko")
    let ticketDate = info.date.toCorrectTime()
    let hour = notiFormatter.string(from: ticketDate)
    
    // Setting content of the notification
    let content = UNMutableNotificationContent()
    content.title = "\(type.emoji) \(info.blue) vs \(info.red)"
    
    switch type {
    case .match:
        content.body = "오늘 \(hour)에 \(info.blue) vs \(info.red) \(type.rawValue)가 있습니다."
    case .ticket:
        content.body = "오늘 \(hour)에 \(info.blue) vs \(info.red) \(type.rawValue)이 있습니다."
    }
    
    // 사용자가 설정한 시간
    var myTime: TimeChoicer
    switch time {
    case 0:
        myTime = TimeChoicer.M0
    case 1:
        myTime = TimeChoicer.M5
    case 2:
        myTime = TimeChoicer.M10
    case 3:
        myTime = TimeChoicer.M20
    case 4:
        myTime = TimeChoicer.M30
    case 5:
        myTime = TimeChoicer.M60
    case 6:
        myTime = TimeChoicer.M120
    default:
        myTime = TimeChoicer.M0
    }
    
    // 몽고디비 시간대 변경하고 유저가 설정한 시간으로 맞춤.
    let settingTime = info.date.convertToSettingTime(time: myTime.time)
    let interval = settingTime.timeIntervalSince(Date())
    let date = Date(timeIntervalSinceNow: interval)
    let dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    // 실전
    //    let calendartrigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: false)
    
    // 테스트용
    let calendartrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5), repeats: false)
    
    //Adding Request
    notiFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
    var id = notiFormatter.string(from: ticketDate)
    
    switch type {
    case .match:
        id.append("m|\(myTime.name)")
    case .ticket:
        id.append("t|\(myTime.name)")
    }
    
    let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: calendartrigger)
    
    // 노티 확인용
//    DispatchQueue.main.async {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
//            Log.info("총 개수 \(requests.count)")
//            for request in requests {
//                Log.info("id \(request.identifier)")
//            }
//        }
//    }
    UNUserNotificationCenter.current().add(request) { (error) in
        if let err = error {
            print(err)
        }
    }
}
