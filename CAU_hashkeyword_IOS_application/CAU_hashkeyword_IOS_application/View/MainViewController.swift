//DeisgnableView
//  ViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 10/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var inputField: UITextField!
    @IBOutlet weak var keywordTextView: UITextView!

    @IBOutlet weak var AniLabel1: UILabel!
    @IBOutlet weak var AniLabel2: UILabel!
    @IBOutlet weak var AniImage: UIImageView!

    @IBOutlet weak var keywordLabel: UILabel! // 이제 안씀

    func show_keyword() {
        // 등록한 키워드 보여주기
        var keywordString:String = ""
        for i in 0..<data_center.keyword.count{
            keywordString += "#"
            keywordString += data_center.keyword[i]
            keywordString += "  "
        }
        keywordTextView?.text = keywordString
    }

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
            // 반복하려면
            /*{(Completed:Bool) -> Void in
                self.animateAlarm()
            }*/)
        })
    }

    // Alert
    let inputAlert = UIAlertController(title:"어이쿠!", message:"키워드가 이미 존재하거나\r\n잘못된 입력입니다.", preferredStyle: .alert)
    let inputAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    @objc func dismissFunc(){
        self.inputAlert.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 애니메이션
        AniLabel1.alpha = 0
        AniLabel2.alpha = 0
        AniImage.alpha = 0

        // 키보드
        inputField.delegate = self // 키보드 내리는데 필요
        inputField.returnKeyType = .done // keyboard 엔터 -> 완료
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap) // 제스처 인식

        // 키워드 목록
        show_keyword()

        // 텍스트 필드
        inputField.placeholder = "키워드 추가하기" // 텍스트필드 값
        inputField.textAlignment = .center // 텍스트 위치
        inputField.borderStyle = UITextField.BorderStyle.none
        inputField.backgroundColor = UIColor.groupTableViewBackground
        inputField.frame.size.width = 283.0
        inputField.layer.borderWidth = 2.0
        inputField.layer.cornerRadius = 3.0
        inputField.layer.borderColor = UIColor.lightGray.cgColor

        // when textField cornerRadius applied..
        /*
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: inputField.frame.height))
        inputField.leftView = paddingView
        inputField.leftViewMode = UITextField.ViewMode.always
        */
        // 그림자 설정
        /*self.inputField.layer.shadowRadius = 3.0
        self.inputField.layer.shadowColor = UIColor.black.cgColor
        self.inputField.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        self.inputField.layer.shadowOpacity = 1.0*/

        // 알림
        inputAlert.addAction(inputAlertAction)
        // 홈 버튼을 누르고 돌아오면 오류메시지 안보이기.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        show_keyword() // reload textView
    }

    //화면 클릭시 키보드 자동 내려가기 // viewDidload() let Tap 부분도 필요함
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 키보드 완료 버튼
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var flag_keyword:Bool = false
        if let new_keyword = inputField.text {
            // 겹치는 키워드가 있는지 확인
            for keyword in data_center.keyword {
                if new_keyword == keyword {
                    flag_keyword = true
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
            if space_count == new_keyword.count { flag_keyword = true }

            if flag_keyword {
                // 이미 있는 키워드입니당 or 공백만 있습니당
                present(inputAlert, animated: true, completion: nil)
            } else {
                inputField.text = "" // 텍스트필드 비우기
                data_center.keyword.append(new_keyword) // data_center에 키워드 추가하기
                show_keyword()
                // 알림드리겠습니당.
                AniLabel1.text = "#" + new_keyword + " 키워드 등록 완료"
                animateAlarm()
            }
        }
        print(data_center.keyword)
        self.view.endEditing(true) // 키보드 숨기기
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
