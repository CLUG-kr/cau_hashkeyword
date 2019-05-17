//
//  DataCenter.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 1/30/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import Foundation

var data_center:DataCenter = DataCenter()

class DataCenter: NSObject, NSCoding {
    var keyword:[String]
    var timeline:[Timeline]
    var cau:Cau
//    var lib:Lib
    var dorm:Dorm
//    var ict:Ict
//    var cse:Cse
    var notiOnOff:Bool
    var website:[String] // 웹사이트 이름을 모아둔다.
    var selectedWebsite:[Int]

    override init(){
        self.keyword = ["장학","수강신청","교환학생","봉사","입관"]
        self.timeline = [Timeline]()
        self.cau = Cau()
        self.dorm = Dorm()
        self.notiOnOff = true
        self.website = ["CAU NOTICE (cau.ac.kr)", "서울캠퍼스 학술정보원 (library.cau.ac.kr)", "서울캠퍼스 생활관 (dormitory.cau.ac.kr)", "창의 ICT 공과대학 (ict.cau.ac.kr)", "소프트웨어학부 (cse.cau.ac.kr)"]
        self.selectedWebsite = [0,1,2,3,4]
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.keyword, forKey: "keyword")
        aCoder.encode(self.timeline, forKey: "timeline")
        aCoder.encode(self.cau, forKey: "cau")
        aCoder.encode(self.dorm, forKey: "dorm")
        aCoder.encode(self.notiOnOff, forKey: "notiOnOff")
        aCoder.encode(self.website, forKey: "website")
        aCoder.encode(self.selectedWebsite, forKey: "selectedWebsite")
    }
    public required init?(coder aDecoder: NSCoder) {
        if let keyword = aDecoder.decodeObject(forKey:"keyword") as? [String]{
            self.keyword = keyword
        } else {
            self.keyword = []
        }
        if let timeline = aDecoder.decodeObject(forKey:"timeline") as? [Timeline]{
            self.timeline = timeline
        } else {
            self.timeline = [Timeline]()
        }
        if let cau = aDecoder.decodeObject(forKey:"cau") as? Cau{
            self.cau = cau
        } else {
            self.cau = Cau()
        }
        if let dorm = aDecoder.decodeObject(forKey:"dorm") as? Dorm{
            self.dorm = dorm
        } else {
            self.dorm = Dorm()
        }
        if let notiOnOff = aDecoder.decodeObject(forKey:"notiOnOff") as? Bool{
            self.notiOnOff = notiOnOff
        } else {
            self.notiOnOff = true
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

class Timeline: NSObject, NSCoding {
    var title:String
    var ref:String
    var date:String
    var url:String

//    override init() {
//        self.title = ""
//        self.ref = ""
//        self.date = ""
//    }
    init(title: String, ref: String, date:String, url:String) {
        self.title = title
        self.ref = ref
        self.date = date
        self.url = url
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.ref, forKey: "ref")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.url, forKey: "url")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String{
            self.title = title
        } else {
            self.title = ""
        }
        if let ref = aDecoder.decodeObject(forKey: "ref") as? String{
            self.ref = ref
        } else {
            self.ref = ""
        }
        if let date = aDecoder.decodeObject(forKey: "date") as? String{
            self.date = date
        } else {
            self.date = ""
        }
        if let url = aDecoder.decodeObject(forKey: "url") as? String{
            self.url = url
        } else {
            self.url = ""
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

class Dorm: NSObject, NSCoding{
    var dorm_date:[String]
    var dorm_title:[String]
    var dorm_url:[String]

    override init(){
        self.dorm_date = []
        self.dorm_title = []
        self.dorm_url = []
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.dorm_date, forKey: "dorm_date")
        aCoder.encode(self.dorm_title, forKey: "dorm_title")
        aCoder.encode(self.dorm_url, forKey: "dorm_url")
    }

    public required init?(coder aDecoder: NSCoder) {
        if let dorm_date = aDecoder.decodeObject(forKey:"dorm_date") as? [String]{
            self.dorm_date = dorm_date
        } else {
            self.dorm_date = []
        }
        if let dorm_title = aDecoder.decodeObject(forKey:"dorm_title") as? [String]{
            self.dorm_title = dorm_title
        } else {
            self.dorm_title = []
        }
        if let dorm_url = aDecoder.decodeObject(forKey:"dorm_url") as? [String]{
            self.dorm_url = dorm_url
        } else {
            self.dorm_url = []
        }
    }
}

