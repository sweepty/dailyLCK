//
//  myTeamTableViewCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/08/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class MyTeamTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = realm.objects(Team.self).filter("heart == true").count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "my Team Cell", for: indexPath) as! MyTeamCollectionViewCell
        if let myTeamList = realm.objects(Team.self).filter("heart == true").value(forKey: "id") as? [Int] {
            switch myTeamList[indexPath.row] {
            case 1: cell.teamLogo.image = UIImage(named: "afs.png")
            case 2: cell.teamLogo.image = UIImage(named: "gen.png")
            case 3: cell.teamLogo.image = UIImage(named: "griffin.png")
            case 4: cell.teamLogo.image = UIImage(named: "hie.png")
            case 5: cell.teamLogo.image = UIImage(named: "jag.png")
            case 6: cell.teamLogo.image = UIImage(named: "kz.png")
            case 7: cell.teamLogo.image = UIImage(named: "kt.png")
            case 8: cell.teamLogo.image = UIImage(named: "mvp.png")
            case 9: cell.teamLogo.image = UIImage(named: "skt.png")
            case 10: cell.teamLogo.image = UIImage(named: "bbq.png")
            default:
                cell.teamLogo.image = UIImage(named: "skt.png")
            }
        }
        
        return cell
    }
    



    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
