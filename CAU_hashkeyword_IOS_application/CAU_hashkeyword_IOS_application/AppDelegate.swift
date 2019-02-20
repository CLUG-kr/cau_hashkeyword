//
//  AppDelegate.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 10/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit
// import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase
        // Use Firebase library to configure APIs
//        FirebaseApp.configure()

        // Override point for customization after application launch.
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        let base_ref:String = "server/saving-data/crawling/webpages"
//        ref.child(base_ref + "/caunotice").observeSingleEvent(of: .value, with: { (snapshot) in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                switch snap.key{
//                case "date":
//                    data_center.cau.cau_date = snap.value as! [String]
//                case "title":
//                    data_center.cau.cau_title = snap.value as! [String]
//                case "url":
//                    data_center.cau.cau_url = snap.value as! [String]
//               default:
//                    print("Firebase reading error")
//                }
//            }
//        })
//    }

//    func applicationWillTerminate(_ application: UIApplication) {
//    }
}
}
