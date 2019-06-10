//
//  AppDelegate.swift
//  LCKforYou
//
//  Created by Seungyeon Lee on 2018. 2. 7..
//  Copyright © 2018년 Seungyeon Lee. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (permissionGranted, error) in
            print(error as Any)
        }
        return true
    }
    
}



