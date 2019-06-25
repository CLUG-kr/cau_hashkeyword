//DeisgnableView
//  ViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 10/01/2019.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class MainViewController: UIViewController, UITextFieldDelegate {

    // Firebase Database
    var ref: DatabaseReference!

    @IBOutlet var inputField: UITextField!
    @IBOutlet weak var keywordTextView: UITextView!

    // 키워드 등록시 등장하는 애니메이션을 위한 Outlet
    @IBOutlet weak var AniLabel1: UILabel!
    @IBOutlet weak var AniLabel2: UILabel!
    @IBOutlet weak var AniImage: UIImageView!

    @IBOutlet weak var keywordLabel: UILabel! // 이제 안씀 -> keywordTextView로 대체

    // 인터넷 연결 상태 Alert
    let networkAlert = UIAlertController(title:"웁스!", message:"사용자 정보를 불러올 수 없습니다.\r\n인터넷 연결을 확인해주세요.", preferredStyle: .alert)
    let networkAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    // 키워드 입력값 Alert
    let inputAlert = UIAlertController(title:"어이쿠!", message:"키워드가 이미 존재하거나\r\n잘못된 입력입니다.", preferredStyle: .alert)
    let inputAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    func show_keyword() {
        // 등록한 키워드 보여주기
        var keywordString:String = ""
        // # 붙여서 표현
        for i in 0..<data_center.keyword.count{
            keywordString += "#"
            keywordString += data_center.keyword[i]
            keywordString += "  "
        }
        keywordTextView?.text = keywordString
    }

    // 애니메이션 효과 지정
    func animateAlarm() {
        // fade in 속도
        UIView.animate(withDuration: 1.0, animations: {
            self.AniLabel1.alpha = 1.0
            self.AniLabel2.alpha = 1.0
            self.AniImage.alpha = 1.0
        }, completion: {
            (Completed: Bool) -> Void in
            // fade out 속도
            UIView.animate(withDuration: 1.0, delay: 3.0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.AniLabel1.alpha = 0
                self.AniLabel2.alpha = 0
                self.AniImage.alpha = 0
            }, completion: nil
            // 반복하려면 (무한히 깜빡거리기?)
            /*{(Completed:Bool) -> Void in
                self.animateAlarm()
            }*/)
        })
    }

    // 홈버튼 누르고 다시 들어오면 입력 오류 메시지 Alert 사라지도록
    @objc func dismissFunc(){
        self.inputAlert.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {

        // 네트워크 연결 실패 알림
        networkAlert.addAction(networkAlertAction)

        // Firebase Configure
        ref = Database.database().reference()
        
        // 만약 로그인한 적이 없다면 로그인 페이지로 이동
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil { // if let 구문으로 Storyboard 가져오기?
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let myLogin = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                self.present(myLogin, animated: true, completion: nil)
            }
        }

        super.viewDidLoad()
        // 애니메이션 부품
        AniLabel1.alpha = 0
        AniLabel2.alpha = 0
        AniImage.alpha = 0

        // 키보드
        inputField.delegate = self // 키보드 내리는데 필요
        inputField.returnKeyType = .done // keyboard 엔터 -> 완료

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap) // 제스처 인식

        // 키워드 목록
        self.show_keyword()

        // 텍스트 필드 왼쪽 여백 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.inputField.frame.height))
        inputField.leftView = paddingView
        inputField.leftViewMode = UITextField.ViewMode.always

        // 텍스트 필드
        inputField.placeholder = "↪︎" // 텍스트필드 placeholder 값, ↩︎ > ⤷ › ✎ ❝❞ 키워드 추가하기
        // inputField.textAlignment = .center // 텍스트 위치 -> paddingView 사용으로 대체
        inputField.borderStyle = UITextField.BorderStyle.none
        inputField.backgroundColor = UIColor.groupTableViewBackground
        inputField.frame.size.width = 283.0
        inputField.layer.borderWidth = 2.0
        inputField.layer.cornerRadius = 3.0
        inputField.layer.borderColor = UIColor.lightGray.cgColor

        // 텍스트 필드 그림자 설정
        /*self.inputField.layer.shadowRadius = 3.0
        self.inputField.layer.shadowColor = UIColor.black.cgColor
        self.inputField.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        self.inputField.layer.shadowOpacity = 1.0*/

        // 키워드 입력 오류 알림
        inputAlert.addAction(inputAlertAction)

        // 홈 버튼을 누르고 돌아오면 오류메시지 안보이기.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.show_keyword() // reload textView // Preference에서 삭제 하고 돌아왔을 때
    }

    //화면 클릭시 키보드 자동 내려가기 // viewDidload() let Tap 부분도 필요함
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func checkKeyword(new_keyword: String) -> (isExist: Bool, isSpace: Bool) {
        var isExist:Bool = false, isSpace:Bool = false
        // 겹치는 키워드가 있는지 확인
        for keyword in data_center.keyword {
            if new_keyword == keyword {
                isExist = true
                break
            }
        }
        // 공백으로만 이루어졌는지 확인 python의 isspace()
        var space_count:Int = 0
        for char in new_keyword {
            if char == " " {
                space_count += 1
            }
        }
        if space_count == new_keyword.count { isSpace = true }
        return (isExist, isSpace)
    }

    // 키보드 완료 버튼
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if connection { // 인터넷 연결 상태
            if let new_keyword = inputField.text {
                if checkKeyword(new_keyword: new_keyword).isExist { // 이미 있는 키워드
                    present(inputAlert, animated: true, completion: nil)
                }
                else if checkKeyword(new_keyword: new_keyword).isSpace { // 공백으로만 이뤄진 키워드
                    present(inputAlert, animated: true, completion: nil)
                    inputField.text = "" // 만약 공백으로만 이루어졌다면 텍스트 필드 값 비우기
                }
                else { // 정상적인 입력인 경우
                    inputField.text = "" // 텍스트필드 비우기
                    data_center.keyword.append(new_keyword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) // data_center에 키워드 추가하기, trim()

                    // Firebase Database에 사용자 키워드 업데이트
                    // 아래를 리스너로 하면 어떤 차이점이 있을까
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        let childUpdates = ["users/\(uid)/keywords": data_center.keyword]
                        ref.updateChildValues(childUpdates)
                    }
                    // keywordTextView Reload
                    show_keyword()
                    // 알림드리겠습니당.
                    AniLabel1.text = "#" + new_keyword + " 키워드 등록 완료"
                    animateAlarm()
                }
            }
            self.view.endEditing(true) // 키보드 숨기기
        } else { // 인터넷 연결 상태가 아님
            present(networkAlert, animated: true, completion: nil)
        }
        return true
    }

    // 상태바 색상 바꾸기
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
