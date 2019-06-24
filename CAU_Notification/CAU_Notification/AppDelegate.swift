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
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    // Firebase Database
    var ref: DatabaseReference!

    // Network Alert
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

        // 구글 로그인후 Firebase에 사용자 정보 추가
        ref = Database.database().reference()
        // 여기서 초기화해야지 에러 안남. FirebaseApp.configure이 먼저 수행되어야 한다. (https://stackoverflow.com/questions/40322481/firebase-app-not-being-configured)

        // guard let idToken = user.authentication.idToken else { return }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        // Firebase Authentication에 인증하는 역할을 한다.
        // 'signInAndRetrieveData(with:completion:)' is deprecated: Please use signInWithCredential:completion: for Objective-C or signIn(with:completion:) for Swift instead.
        Auth.auth().signIn(with: credential) { (authResult, error) in

            if let error = error {
                print("Faild to create a Firebase User with Google account: ", error)
                // 사용자에게 메시지?
            }

            let isNewUser = authResult?.additionalUserInfo?.isNewUser;
            // Auth.auth().addStateDidChangeListener { (auth, user) in
            // 리스너로 하면 새로운 유저처럼 또 초기화되어 버린다.. 왜지?
            let user = Auth.auth().currentUser
                if let user = user {
                    if(isNewUser!) { // 만약 처음 로그인한 유저라면 Firebase에 정보 추가
                        // The user's ID, unique to the Firebase project.
                        // Do NOT use this value to authenticate with your backend server,
                        // if you have one. Use getTokenWithCompletion:completion: instead.
                        let uid = user.uid
                        let email = user.email
                        // 기본 설정 적용 (키워드 및 선택한 웹사이트)
                        let user_data = ["email": email!, "push_notification": true, "keywords": ["장학","수강신청","교환학생","봉사","입관"], "selectedWebsite": ["CAU NOTICE (cau.ac.kr)", "서울캠퍼스 학술정보원 (library.cau.ac.kr)", "서울캠퍼스 생활관 (dormitory.cau.ac.kr)", "창의 ICT 공과대학 (ict.cau.ac.kr)", "소프트웨어학부 (cse.cau.ac.kr)"]] as [String : Any]
                        let childUpdates = ["users/\(uid)/": user_data]
                        self.ref.updateChildValues(childUpdates)
                        // rootViewController 지정은 if문에도 남겨주어야 한다
                        // 아래 else에서는 observe 안에 들어있기 때문이다
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let myTabBar = storyboard.instantiateViewController(withIdentifier: "mainTBC") as! UITabBarController
                        self.window?.rootViewController = myTabBar
                    } else { // 기존에 Firebase Authentication에 있던 유저라면
                        let base_ref:String = "users"
                        self.ref.child(base_ref + "/\(user.uid)/").observeSingleEvent(of: .value, with: { (snapshot) in
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                switch snap.key{
                                case "email":
                                    print("emailCheck")
                                case "push_notification":
                                    data_center.notiOnOff = snap.value as! Bool
                                    print(data_center.notiOnOff)
                                case "keywords":
                                    data_center.keyword = snap.value as! [String]
                                    print(data_center.keyword)
                                case "selectedWebsite":
                                    let selectedWebsite = snap.value as! [String]
                                    print(selectedWebsite)
                                    // String형으로 이루어진 웹사이트의 모음을 WebsiteTVC에 대한 인덱스로 변환
                                    data_center.selectedWebsite = []
                                    // 이중 for문 okay..?
                                    for websiteName in selectedWebsite {
                                        var i = 0
                                        for website in data_center.website {
                                            if (websiteName == website) { // swift는 operator overloading임
                                                data_center.selectedWebsite.append(i)
                                            }
                                            i += 1
                                        }
                                    }
                                    print(data_center.selectedWebsite)
                                    // data_center.website와 data_center.selectedWebsite를 딕셔너리로 안한 이유가 무엇이었을까?
                                default:
                                    print("Firebase reading error : User")
                                }
                            }
                            // 이렇게 observe 안에 넣어주어야지 키워드를 불러오고 나서 Main을 보여준다.
                            // 속도는 아주 살짝 느려지더라도 감수하기
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let myTabBar = storyboard.instantiateViewController(withIdentifier: "mainTBC") as! UITabBarController
                            self.window?.rootViewController = myTabBar
                        })
                    }
                    // fcmToken 등록
                    let pushManager = PushNotificationManager(userID: user.uid)
                    pushManager.registerForPushNotifications()
                }
            // }
            // guard let uid = user.userID else { return }
            // print("Successfully logged into Firebase with Google", uid)
        }
    }

    @objc func dismissFunc(){
        self.inputAlert.dismiss(animated: true, completion: nil)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        // 구글 로그인후 Firebase에 사용자 정보 추가
        ref = Database.database().reference()

        // terminate 상태에서 Main으로 돌아올 때 실행되는 부분으로 Firebase에서 키워드 정보를 가져옴.
        // 후에 아카이브로 해결할까..?
        let user = Auth.auth().currentUser
        if let user = user {
            let base_ref:String = "users"
            self.ref.child(base_ref + "/\(user.uid)/").observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    switch snap.key{
                    case "email":
                        print("emailCheck")
                    case "push_notification":
                        data_center.notiOnOff = snap.value as! Bool
                    case "keywords":
                        data_center.keyword = snap.value as! [String]
                    case "selectedWebsite":
                        let selectedWebsite = snap.value as! [String]
                        data_center.selectedWebsite = []
                        for websiteName in selectedWebsite {
                            var i = 0
                            for website in data_center.website {
                                if (websiteName == website) { // swift는 operator overloading임
                                    data_center.selectedWebsite.append(i)
                                }
                                i += 1
                            }
                        }
                    default:
                        print("Firebase reading error : User")
                    }
                }
                // 이렇게 observe 안에 넣어주어야지 키워드를 불러오고 나서 Main을 보여준다.
                // 속도는 아주 살짝 느려지더라도 감수하기
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let myTabBar = storyboard.instantiateViewController(withIdentifier: "mainTBC") as! UITabBarController
                self.window?.rootViewController = myTabBar
            })
        }

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


        // 실시간으로 변경된 값을 Firebase에 업데이트하는 것이 나을까
        // 여기서 한꺼번에 업데이트 하는 것이 더 나을까


    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func checkNetwork() {
        let monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { path in // 인터넷 연결 상태 수시로 체크
            if path.status == .satisfied {
                print("We're connected!")
                connection = true
            } else {
                print("No connection.")
                connection = false
            }
            // print(path.isExpensive) // Cellular 여부 확인
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        print("액티브")
        // 인터넷 연결 수시로 확인
        checkNetwork()

        ref = Database.database().reference()
        let base_ref:String = "crawling/webpages"
        ref.child(base_ref + "/dormitory").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                switch snap.key{
                case "date":
                    data_center.dorm.dorm_date = snap.value as! [String]
                case "title":
                    data_center.dorm.dorm_title = snap.value as! [String]
                case "url":
                    data_center.dorm.dorm_url = snap.value as! [String]
                default:
                    print("Firebase reading error : Dormitory")
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
