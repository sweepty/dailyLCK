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

    override func viewDidLoad() {
        super.viewDidLoad()
//        teamList.sort()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20) // top left bottom right
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
}
