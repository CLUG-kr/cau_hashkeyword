//DeisgnableView
//  ViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 10/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var inputField: UITextField!
    @IBOutlet var outputField: UILabel!
    
//    var keywordList = []

    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Called just before UITextField is edited
    private func textFieldDidBeginEditing(_ inputField: UITextField) {
        print("textFieldDidBeginEditing: \((inputField.text) ?? "Empty")")
    }
    
    // Called immediately after UITextField is edited
    private func textFieldDidEndEditing(_ inputField: UITextField) {
        print("textFieldDidBeginEditing: \((inputField.text) ?? "Empty")")
    }
    
    func textFieldShouldReturn(_ inputField: UITextField) -> Bool {
        print("textFieldShouldReturn \((inputField.text) ?? "Empty")")
//        keywordList.append(inputField.text)
        // Process of closing the Keyboard when the line feed button is pressed.
        inputField.resignFirstResponder();
        var label: UILabel = {
            // Label Create.
            let label: UILabel = UILabel(frame: CGRect(x: 102.0, y: 346.0, width: 171.0, height: 20.0))
            // Define background color.
            label.backgroundColor = UIColor.clear
            // Define text color.
            label.textColor = UIColor.lightGray
            // Define text font.
            label.font = .systemFont(ofSize: 17, weight: .light)
            // Define text of label.
            // Define count of line.
            // '0' is infinity label.numberOfLines = 0
            // Round UILabel frame.
            label.layer.masksToBounds = true
            // Define text Alignment.
            // options) .left, .right, .center, .justified, .natural
            label.textAlignment = .center
            
//            for i in keywordList {
//                label.text = label.text! + " #" + keywordList[i]
//            }
            
            return label
        }()
            

        return true
    }
    
}
