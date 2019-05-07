//
//  AppDelegate.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 10/01/2019.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    // Alert
    let inputAlert = UIAlertController(title:"저런!", message:"인터넷이 연결되었는지 확인해주세요.", preferredStyle: .alert)
    let inputAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    // login 후에 다시 앱으로 돌아오는 역할
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        if let error = error {
            print("Failed to log into Google: ", error)
            // 사용자에게 로그인 실패 메시지?
            return
        }
        print("Successfully logged into Google", user)

        // guard let idToken = user.authentication.idToken else { return }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        // 아래의 역할은 무엇인가
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Faild to create a Firebase User with Google account: ", error)
                // 사용자에게 메시지?
            }
            guard let uid = user.userID else { return }
            print("Successfully logged into Firebase with Google", uid)
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "mainTBC") as! UITabBarController
            self.window?.rootViewController = myTabBar
        }
    }

    @objc func dismissFunc(){
        self.inputAlert.dismiss(animated: true, completion: nil)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        /*
        inputAlert.addAction(inputAlertAction)
        // 홈 버튼을 누르고 돌아오면 오류메시지 안보이기.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)
        */

//        var initialViewController: UIViewController?
//        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user == nil {
//                print()
//                print()
//                print("This is Login view")
//                initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC")
//            } else {
//                initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainTVC")
//            }
//        }
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()

        // 알림허용 묻기
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in })

        // 구글 로그인
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

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
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let base_ref:String = "server/saving-data/crawling/webpages"
        ref.child(base_ref + "/caunotice").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                switch snap.key{
                case "date":
                    data_center.cau.cau_date = snap.value as! [String]
                case "title":
                    data_center.cau.cau_title = snap.value as! [String]
                case "url":
                    data_center.cau.cau_url = snap.value as! [String]
                default:
                    print("Firebase reading error")
                }
            }
        })
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
/*
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
 */
    
}
