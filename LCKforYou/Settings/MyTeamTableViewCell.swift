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
        if let myTeamList: [String] = realm.objects(Team.self).filter("heart == true").value(forKey: "name") as? [String] {
            cell.teamLogo.image = UIImage(named: myTeamList[indexPath.row].convertToInitialism())
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
