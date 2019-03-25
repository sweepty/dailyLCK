//
//  DetailViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 08/02/2019.
//  Copyright © 2019 Seungyeon Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var info: Matches?
    
    let formatter = DateFormatter()

    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var redImageView: UIImageView!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    
    @IBOutlet weak var ticketDateLabel: UILabel!
    
    @IBAction func ticketAlarmButton(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redImageView.image = UIImage(named: (info?.red)!)
        blueImageView.image = UIImage(named: (info?.blue)!)
        
        blueLabel.text = changeFullName(name: (info?.blue)!)
        redLabel.text = changeFullName(name: (info?.red)!)
        
        formatter.dateFormat = "yyyy년 M월 dd일 EEE a h:mm"
        formatter.locale = Calendar.current.locale
        
        let matchDateLocaltime = info?.mDate.toCorrectTime()
        let matchDate = formatter.string(from: matchDateLocaltime!)
        matchDateLabel.text = matchDate
        stadiumLabel.text = info?.stadium
        
        
        let ticketDateLocaltime = info?.tDate.toCorrectTime()
        let ticketDate = formatter.string(from: ticketDateLocaltime!)
        ticketDateLabel.text = ticketDate
        
        blueLabel.sizeToFit()
        redLabel.sizeToFit()
        stadiumLabel.sizeToFit()
        matchDateLabel.sizeToFit()
        ticketDateLabel.sizeToFit()
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
