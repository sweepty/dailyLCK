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
class SelectTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var teamList = ["Afreeca Freecs", "bbq Olivers", "Gen.G", "Griffin", "Hanwha Life Esports", "Jin Air Greenwings", "KING-ZONE DragonX" ,"KT Rolster", "MVP" ,"SK Telecom T1"]
    
    let realm = try! Realm()
    var teams: Results<Team>?

    // 팀 선택 버튼
    @IBAction func touchTeamLogoButton(_ sender: UIButton) {
        print("@@@@@@@@@@@@@@@@@@@@@@@@ \(sender.tag)")
//        let myid = teams?.filter("id == %@", 1)
//        if let salmon = myid {
//            print("ttrueee")
//            print("\(salmon)")
//        } else {
//            print("liar")
//        }
//        print("\(teams?.filter("id == %@", myid).value(forKey: <#T##String#>))")
//        if let teamId: Int = id as? Int {

//            let heart = teams?.filter("id == %@", teamId).value(forKey: "heart")

//            if let changeHeart = heart as? Bool {
//                Team.update(teamId, changeHeart == true ? false : true)
////                _ = UIAlertController(title: "팀을 설정했습니다.", message: "\(teamList[sender.tag])의 설정이 변경되었습니다", preferredStyle: UIAlertControllerStyle.alert)
//            }
//        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
        switch teamList[indexPath.row] {
        case "Afreeca Freecs": cell.teamButton.setImage(UIImage(named: "afs.png"), for: .normal)
        case "bbq Olivers": cell.teamButton.setImage(UIImage(named: "bbq.png"), for: .normal)
        case "Gen.G": cell.teamButton.setImage(UIImage(named: "gen.png"), for: .normal)
        case "Griffin": cell.teamButton.setImage(UIImage(named: "griffin.png"), for: .normal)
        case "Hanwha Life Esports": cell.teamButton.setImage(UIImage(named: "hie.png"), for: .normal)
        case "Jin Air Greenwings": cell.teamButton.setImage(UIImage(named: "jag.png"), for: .normal)
        case "KING-ZONE DragonX": cell.teamButton.setImage(UIImage(named: "kz.png"), for: .normal)
        case "KT Rolster": cell.teamButton.setImage(UIImage(named: "kt.png"), for: .normal)
        case "MVP": cell.teamButton.setImage(UIImage(named: "mvp.png"), for: .normal)
        default:
            cell.teamButton.setImage(UIImage(named: "skt.png"), for: .normal)
        }
        cell.teamButton.setTitle(teamList[indexPath.row], for: .normal)
        
        // 팀 선택 handler
        cell.teamButton.tag = indexPath.row + 1
        cell.teamButton.addTarget(self, action: #selector(touchTeamLogoButton), for: .touchUpInside)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        teamList.sort()
        collectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20) // top left bottom right
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
}
