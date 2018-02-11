//
//  ViewController.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 7..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//
import UIKit
import Kanna
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURLString = "http://www.ticketlink.co.kr/product/22645"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            let dayofOpen = myHTMLString.range(of: "예매오픈 : ", options: NSString.CompareOptions.literal, range: myHTMLString.startIndex..<myHTMLString.endIndex, locale: nil)
            let endofIndex = myHTMLString.range(of: "</p><p>예매매수", options: NSString.CompareOptions.literal, range: myHTMLString.startIndex..<myHTMLString.endIndex, locale: nil)
            
            if let range = dayofOpen, let range2 = endofIndex {
                let start = range.lowerBound
                let end = range2.lowerBound
                let result = myHTMLString[start..<end]
                print(result)
            
            }

        } catch let error {
            print("Error: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

