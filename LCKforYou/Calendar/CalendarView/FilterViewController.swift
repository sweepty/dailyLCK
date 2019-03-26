//
//  FilterViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 18/03/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    public var teamList = [Teams]()
    
    override func viewWillAppear(_ animated: Bool) {
        insertTeams { (con, teams) in
            guard let result = teams else {
                return
            }
            self.teamList = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController: UITableViewDelegate {
    // 셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let selected = self.teamList[indexPath.row].name
        // DB에 존재하지 않음.
        if !self.teamList.isEmpty {
            if realm.objects(Team.self).filter("name == %@", selected).isEmpty {
                print("처음 추가")
                Team.add(selected, true)

            } else {
                if realm.objects(Team.self).filter("name == %@", self.teamList[indexPath.row].name)[0].value(forKeyPath: "heart") as? Bool == true {
                    Team.updateHeart(selected, false)
                    print("💙")

                } else {
                    Team.updateHeart(selected, true)
                    print("❤️")
                }
                
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = teamList[indexPath.row].name
        if !self.teamList.isEmpty {
            if realm.objects(Team.self).filter("name == %@", self.teamList[indexPath.row].name).first?.value(forKeyPath: "heart") as? Bool == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
}
