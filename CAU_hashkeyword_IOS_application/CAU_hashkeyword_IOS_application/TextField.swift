//
//  TextField.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Hyeseong Kim on 14/01/2019.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
//    override func canBecomeFirstResponder() -> Bool {
//        return true
//    }
    
    override func becomeFirstResponder() -> Bool {
        layer.borderColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0).cgColor
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        layer.borderWidth = 3
        super.becomeFirstResponder()
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        layer.borderColor = UIColor.clear.cgColor
        super.resignFirstResponder()
        
        return true
    }
    
}

extension CALayer {
    var customBorderColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
