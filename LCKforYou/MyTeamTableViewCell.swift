//
//  myTeamTableViewCell.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 03/08/2018.
//  Copyright © 2018 Seungyeon Lee. All rights reserved.
//

import UIKit

class MyTeamTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //임시
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "my Team Cell", for: indexPath) as! MyTeamCollectionViewCell
        cell.teamLogo.image = UIImage(named: "skt.png")
        return cell
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
//        collectionView.scroll
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
