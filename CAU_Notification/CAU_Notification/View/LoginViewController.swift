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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
