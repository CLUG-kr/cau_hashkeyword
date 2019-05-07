//
//  LoginViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 3/14/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.uiDelegate = self
        // 구글 로그인 버튼 넓게
        GoogleSignInButton.style = .wide
    }

    @IBAction func googleSignInButton(_ sender: Any) {
        // 구글 로그인 실행
        GIDSignIn.sharedInstance()?.signIn()
    }


    // AppDelegate의 func didSingInForUser:withError 로 대체

//    override func viewDidAppear(_ animated: Bool) {
//        // 로그인 완료시
//        if Auth.auth().currentUser != nil {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let myTabBar = storyboard.instantiateViewController(withIdentifier: "mainTBC") as! UITabBarController
//            self.present(myTabBar, animated: true, completion: nil)
//        }
//        // MainViewController에서 부르고 여기서 dismiss하기?
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
