//
//  SelectTeamViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 7. 26..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit

class SelectTeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var teamList = ["Afreeca Freecs", "bbq Olivers", "Gen.G", "Griffin", "Hanwha Life Esports", "Jin Air Greenwings", "KING-ZONE DragonX" ,"KT Rolster", "MVP" ,"SK Telecom T1"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCollectionViewCell", for: indexPath) as! teamCollectionViewCell
        
//        switch teamList[indexPath.row] {
//        case 0: cell.logo.image = UIImage(named: "afs.png")
//        case 1: cell.logo.image = UIImage(named: "bbq.png")
//        case 2: cell.logo.image = UIImage(named: "ksv.png")
//        case 3: cell.logo.image = UIImage(named: "griffin.png")
//        case 4: cell.logo.image = UIImage(named: "hie.png")
//        case 5: cell.logo.image = UIImage(named: "jag.png")
//        case 6: cell.logo.image = UIImage(named: "kz.png")
//        case 7: cell.logo.image = UIImage(named: "kt.png")
//        case 8: cell.logo.image = UIImage(named: "mvp.png")
//        default:
//            cell.logo.image = UIImage(named: "skt.png")
//        }
        //로고 임시용
        cell.logo.image = UIImage(named: "skt.png")
        cell.name.text = teamList[indexPath.row]
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        teamList.sort()
    }
}
