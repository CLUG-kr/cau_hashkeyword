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
    var keyword:[String]
    var cau:Cau
//    var lib:Lib
//    var dorm:Dorm
//    var ict:Ict
//    var cse:Cse
    var website:[String]
    var selectedWebsite:[Int]

    override init(){
        self.keyword = ["장학","교환학생","봉사","입관"]
        self.cau = Cau()
        self.website = ["CAU NOTICE (www.cau.ac.kr)", "서울캠퍼스 학술정보원 (library.cau.ac.kr)", "서울캠퍼스 생활관 (dormitory.cau.ac.kr)", "창의 ICT 공과대학 (ict.cau.ac.kr)", "소프트웨어학부 (cse.cau.ac.kr)"]
        self.selectedWebsite = [0,1,2,3,4]
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.keyword, forKey: "keyword")
        aCoder.encode(self.cau, forKey: "cau")
        aCoder.encode(self.website, forKey: "website")
        aCoder.encode(self.selectedWebsite, forKey: "selectedWebsite")
    }
    public required init?(coder aDecoder: NSCoder) {
        if let keyword = aDecoder.decodeObject(forKey:"keyword") as? [String]{
            self.keyword = keyword
        } else {
            self.keyword = []
        }
        if let cau = aDecoder.decodeObject(forKey:"cau") as? Cau{
            self.cau = cau
        } else {
            self.cau = Cau()
        }
        if let website = aDecoder.decodeObject(forKey:"website") as? [String]{
            self.website = website
        } else {
            self.website = []
        }
        if let selectedWebsite = aDecoder.decodeObject(forKey:"selectedWebsite") as? [Int]{
            self.selectedWebsite = selectedWebsite
        } else {
            self.selectedWebsite = []
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

