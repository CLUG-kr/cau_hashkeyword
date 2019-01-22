//
//  ViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 10/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: TextField!
    @IBOutlet var serialNumberField: TextField!
    @IBOutlet var valueField: TextField!
    @IBOutlet var dateLabel: UILabel!
}

