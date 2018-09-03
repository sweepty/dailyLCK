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
        // Use Firebase library to configure APIs
        let _ = Init()
        return true
    }
    
    
}



