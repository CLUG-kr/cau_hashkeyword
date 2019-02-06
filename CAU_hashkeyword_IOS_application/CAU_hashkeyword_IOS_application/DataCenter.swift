//
//  DataCenter.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 1/30/19.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import Foundation

var data_center:DataCenter = DataCenter()

class DataCenter: NSObject, NSCoding {
    var cau:Cau
//    var lib:Lib
//    var dorm:Dorm
//    var ict:Ict
//    var cse:Cse

    override init(){
        self.cau = Cau()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cau, forKey: "cau")
    }
    public required init?(coder aDecoder: NSCoder) {
        if let cau = aDecoder.decodeObject(forKey:"cau") as? Cau{
            self.cau = cau
        } else {
            self.cau = Cau()
        }
    }
}

class Cau: NSObject, NSCoding{
    var cau_date:[String]
    var cau_title:[String]
    var cau_url:[String]

    override init(){
        self.cau_date = []
        self.cau_title = []
        self.cau_url = []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cau_date, forKey: "cau_date")
        aCoder.encode(self.cau_title, forKey: "cau_title")
        aCoder.encode(self.cau_url, forKey: "cau_url")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let cau_date = aDecoder.decodeObject(forKey:"cau_date") as? [String]{
            self.cau_date = cau_date
        } else {
            self.cau_date = []
        }
        if let cau_title = aDecoder.decodeObject(forKey:"cau_title") as? [String]{
            self.cau_title = cau_title
        } else {
            self.cau_title = []
        }
        if let cau_url = aDecoder.decodeObject(forKey:"cau_url") as? [String]{
            self.cau_url = cau_url
        } else {
            self.cau_url = []
        }
    }
}

