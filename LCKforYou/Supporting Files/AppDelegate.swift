//
//  AppDelegate.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 7..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

var uiRealm  = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
//    let center = UNUserNotificationCenter.current()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
//        if uiRealm.isEmpty {
//            let _ = Init()
//        }
//
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//
//        if launchedBefore  {
//            print("Not first launch.")
//        } else {
//            print("First launch, setting UserDefault.")
//            let options: UNAuthorizationOptions = [.alert, .sound]
//            center.requestAuthorization(options: options) {
//                (granted, error) in
//                if !granted {
//                    print("Something went wrong")
//                }
//            }
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//        }
//        return true
//    }
    
}



