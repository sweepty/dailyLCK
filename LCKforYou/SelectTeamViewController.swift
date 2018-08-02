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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
        
        switch teamList[indexPath.row] {
        case "Afreeca Freecs": cell.button.setImage(UIImage(named: "afs.png"), for: .normal)
        case "bbq Olivers": cell.button.setImage(UIImage(named: "bbq.png"), for: .normal)
        case "Gen.G": cell.button.setImage(UIImage(named: "gen.png"), for: .normal)
        case "Griffin": cell.button.setImage(UIImage(named: "griffin.png"), for: .normal)
        case "Hanwha Life Esports": cell.button.setImage(UIImage(named: "hie.png"), for: .normal)
        case "Jin Air Greenwings": cell.button.setImage(UIImage(named: "jag.png"), for: .normal)
        case "KING-ZONE DragonX": cell.button.setImage(UIImage(named: "kz.png"), for: .normal)
        case "KT Rolster": cell.button.setImage(UIImage(named: "kt.png"), for: .normal)
        case "MVP": cell.button.setImage(UIImage(named: "mvp.png"), for: .normal)
        default:
            cell.button.setImage(UIImage(named: "skt.png"), for: .normal)
        }
        cell.button.setTitle(teamList[indexPath.row], for: .normal)

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        teamList.sort()
        collectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20) // top left bottom right
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }
}
