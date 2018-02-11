//
//  ScheduleViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 12..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import Kanna

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var scheduleList: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainURL = "http://www.ticketlink.co.kr/esports/main"
        guard let main = URL(string: mainURL) else {
            print("Error: \(mainURL) doesn't seem to be a valid URL")
            return
        }
        
        
        do {
            let lolMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: lolMain, encoding: .utf8)
            //            let dd =  lolMain.
            for product in doc.xpath("//div[@class='in']") {
                if let productURL = product.at_xpath("a/strong"){
                    if let schedule = productURL.text, schedule.contains("[") {
                        print(schedule)
                        scheduleList.append(schedule)
                    }
                    
                }

                
                print(scheduleList.count)
                
            }
            
        } catch let error {
            print("Error: \(error)")
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 테이블 행수 얻기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleList.count
    }
    
    // 셀 내용 변경하기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let task = self.scheduleList[indexPath.row]
        cell.textLabel?.text = task
        return cell
    }
}

//extension ScheduleViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.scheduleList.count
//    }
//
//    // n번째 섹션의 m번째 row를 그리는데 필요한 셀을 반환합니다.
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let task = self.scheduleList[indexPath.row]
//        cell.textLabel?.text = task
////            .textLabel?.text = task
//        return cell
//
//    }
//}

