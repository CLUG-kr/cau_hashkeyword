//DeisgnableView
//  ViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 10/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var inputField: UITextField!
    @IBOutlet weak var keywordTextView: UITextView!

    @IBOutlet weak var keywordLabel: UILabel! // 이제 안씀

    func show_keyword() {
        // 등록한 키워드 보여주기
        var keywordString:String = ""
        for i in 0..<data_center.keyword.count{
            keywordString += "#"
            keywordString += data_center.keyword[i]
            keywordString += " "
        }
        keywordTextView?.text = keywordString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self // 키보드 내리는데 필요
        inputField.returnKeyType = .done

        show_keyword()

        inputField.placeholder = "키워드 추가하기" // 텍스트필드 값
        inputField.textAlignment = .center
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap) // 키보드

        self.inputField.frame.size.width = 283.0
        self.inputField.layer.borderWidth = 2.0
        self.inputField.layer.cornerRadius = 3.0
        self.inputField.layer.borderColor = UIColor.lightGray.cgColor
        self.inputField.layer.shadowRadius = 3.0
        self.inputField.layer.shadowColor = UIColor.black.cgColor
        self.inputField.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        self.inputField.layer.shadowOpacity = 1.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    //화면 클릭시 키보드 자동 내려가기 // viewDidload() let Tap 부분도 필요함
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 키보드 완료 버튼 누르면 키보드 숨기기
    // data_center에 키워드 추가하기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let new_keword = inputField.text{
            data_center.keyword.append(new_keword)
        }
        print(data_center.keyword)
        inputField.text = "" // 텍스트필드 비우기
        show_keyword()
        self.view.endEditing(true)
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
