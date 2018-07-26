//
//  SelectTeamViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 7. 26..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit

class SelectTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var teamList = ["Afreeca Freecs", "bbq Olivers", "Gen.G", "Griffin", "Hanwha Life Esports", "Jin Air Greenwings", "KING-ZONE DragonX" ,"KT Rolster", "MVP" ,"SK Telecom T1"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! TeamCell
//        cell.textLabel?.text = teamList[indexPath.row]
        cell.logo.image = UIImage(named: "hie.png")
        cell.name.text = teamList[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        teamList.sort()
    }
}
