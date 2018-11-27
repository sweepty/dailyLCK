//
//  SelectTeamViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 7. 26..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import UserNotifications

class SelectTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var teamList = ["Afreeca Freecs", "Gen.G", "Griffin", "Hanwha Life Esports", "Jin Air Greenwings", "KING-ZONE DragonX" ,"KT Rolster", "MVP" ,"SK Telecom T1", "bbq Olivers"]
    
    let realm = try! Realm()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
        switch teamList[indexPath.row] {
        case "Afreeca Freecs": cell.teamImageView.image = UIImage(named: "afs")
        case "bbq Olivers": cell.teamImageView.image = UIImage(named: "bbq")
        case "Gen.G": cell.teamImageView.image = UIImage(named: "gen")
        case "Griffin": cell.teamImageView.image = UIImage(named: "griffin")
        case "Hanwha Life Esports": cell.teamImageView.image = UIImage(named: "hle")
        case "Jin Air Greenwings": cell.teamImageView.image = UIImage(named: "jag")
        case "KING-ZONE DragonX": cell.teamImageView.image = UIImage(named: "kz")
        case "KT Rolster": cell.teamImageView.image = UIImage(named: "kt")
        case "SK Telecom T1": cell.teamImageView.image = UIImage(named: "skt")
        case "MVP": cell.teamImageView.image = UIImage(named: "mvp")
        default:
            cell.teamImageView.image = UIImage(named: "mvp")
        }
        if let isHearted: Bool = realm.objects(Team.self).filter("id == %@", indexPath.row + 1)[0].value(forKey: "heart") as? Bool {
            if isHearted == true {
                cell.teamBoxView.layer.borderColor = UIColor.red.cgColor
            } else {
                cell.teamBoxView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        cell.teamBoxView.layer.borderWidth = 2
        cell.teamBoxView.layer.cornerRadius = 10
        cell.teamLabel.text = teamList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let teamId = indexPath.row + 1
        if let heart = realm.objects(Team.self).filter("id == %@", teamId)[0].value(forKeyPath: "heart") as? Bool {
            if heart == true {
                Team.updateHeart(teamId, false)
                print("취소")
            } else {
                Team.updateHeart(teamId, true)
                print("하트")
                
            }
        }
    }
    
//    // 경기 시작 알림
//    func setMatchNotification(_ teamId: Int) {
//        let now = Date()
//        let calendar = Calendar.current
//        let teamName: String = (realm.objects(Team.self).filter("id ==%@", teamId).value(forKey: "name") as? String)!
//
//        let leftBaseQuery = realm.objects(Match.self).filter("teamLeft == %@", teamName)
//        // 경기날
//        let leftTeamDate = leftBaseQuery.value(forKey: "date")
//        // 적팀
//        let leftOpp = leftBaseQuery.value(forKey: "teamRight")
////        let rightQuery = realm.objects(Match.self).filter("teamRight == %@", teamName).filter("date")
//
//        for mDate in leftBaseQuery {
//            let dateGap = calendar.dateComponents([.year, .month, .day, .hour], from: now, to: mDate)
//            if case let (y?, m?, d?, h?) = (dateGap.year, dateGap.month, dateGap.day, dateGap.hour)
//            {
//                print("\(y)년 \(m)개월 \(d)일 \(h)시간 후")
//                notificating(m, Int(ticketingTime[4])!,String(describing: mTitle!), "티켓팅")
//            }
//        }
////
////        var ticketingTime = tmp.components(separatedBy: ["-"," ",":"])
////        notificating(Int(ticketingTime[3])!, Int(ticketingTime[4])!,String(describing: mTitle!), "티켓팅")
//    }
//    
//    func notificating(_ hh: Int, _ mm: Int, _ title:String, _ type: String){
//        //local notification
//        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
//            switch notificationSettings.authorizationStatus {
//            case .notDetermined:
//                // Request Authorization
//                self.requestAuthorization(completionHandler: { (success) in
//                    guard success else { return }
//                    // Schedule Local Notification
//                    self.scheduleLocalNotification(hh, mm, title, type)
//                })
//            case .authorized:
//                // Schedule Local Notification
//                self.scheduleLocalNotification(hh, mm, title, type)
//                
//            case .denied:
//                //여기 alert로 알려주도록 하기 (예정)
//                print("Application Not Allowed to Display Notifications")
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20) // top left bottom right
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
}
