//
//  ProfileViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 13/07/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "my Team Cell", for: indexPath) as! MyTeamCollectionViewCell
        cell.teamLogo.image = UIImage(named: "skt.png")

        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myTeamCollectionView: UICollectionView!
    
    let sectionList :[String] = ["설정", "피드백", "LckforYou"]
    
    let settingList :[String] = ["나의 팀 설정", "앱 알림 설정"]
    let supportList :[String] = ["개발자에게 이메일 보내기", "앱 평가하기"]
    let lckforyouList :[String] = ["공유하기", "트위터"]
    
    let sbList :[String] = ["selectTeam","setAlert"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "설정"
        
    }
    
    // tableview

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        default:
            return sectionList[section-1]
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return settingList.count
        case 2: return supportList.count
        default: return lckforyouList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell3", for: indexPath) as! MyTeamTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell2")!
            cell.textLabel?.text = settingList[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell")!
            cell.textLabel?.text = supportList[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell")!
            cell.textLabel?.text = lckforyouList[indexPath.row]
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vcName = sbList[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: vcName)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return UITableViewAutomaticDimension
        }
    }
}
