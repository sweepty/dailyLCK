//
//  AppDelegate.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 7..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import RealmSwift

var uiRealm  = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            let _ = Init()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        return true
    }    
    
}



