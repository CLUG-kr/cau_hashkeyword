//
//  PreferenceTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

// Firebase Database
var ref: DatabaseReference!

// 사용하지 않는 nib 코드를 제거하지 않으면 속도 상 문제가 있을까?

class NotiCell: UITableViewCell {
    @IBOutlet weak var noti_cell_label: UILabel!
    @IBOutlet weak var noti_cell_switch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 푸시 알림 스위치 초기화 from Firebase
        noti_cell_switch.isOn = data_center.notiOnOff
    }
}

class KeywordCell: UITableViewCell {
    @IBOutlet weak var keyword_cell_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class SelectedWebsiteCell: UITableViewCell {
    @IBOutlet weak var selectedWebsite_cell_label: UILabel!
    @IBOutlet weak var addWebsite_cell_button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class LogoutCell: UITableViewCell {
    @IBOutlet weak var logout_cell_button_outlet: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class PreferenceTableViewController: UITableViewController {

    // Push Notification 허용 상태 Alert
    let allowPushAlert = UIAlertController(title: "푸시 알림을 허용해주세요!", message: "설정>알림>CAU알림 에서\r\n알림허용을 해주세요.", preferredStyle: .alert)
    let allowPushAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)

    // 인터넷 연결 상태 Alert
    let networkAlert = UIAlertController(title:"웁스!", message:"사용자 정보를 불러올 수 없습니다.\r\n인터넷 연결을 확인해주세요.", preferredStyle: .alert)
    let networkAlertAction = UIAlertAction(title:"확인", style: .default, handler: nil)

    // Firebase에 등록되어 있는 계정 로그아웃하기
    @IBAction func logOutButton(_ sender: Any) {
        if connection {
            let logOutSheet = UIAlertController(title: nil, message: "정말로 로그아웃 하시겠습니까?", preferredStyle: .actionSheet)

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let logOut = UIAlertAction(title: "로그아웃", style: .destructive) { action in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()

                    // 아래 코드로 로그아웃시 새로운 구글 계정으로 로그인할 수 있음.
                    GIDSignIn.sharedInstance().signOut()
                    // GIDSignIn.sharedInstance().disconnect() // 탈퇴용?
                    // (https://stackoverflow.com/questions/37936560/how-to-sign-out-of-google-after-being-authenticated)

                    // let user = Auth.auth().currentUser

                    // 아래 코드는 데이터베이스에 있는 유저 데이터를 삭제하는 듯. 즉, 탈퇴시에만 하면 될듯.
                    /*
                     user?.delete { error in
                        if let error = error {
                            print("유저 삭제 에러")
                            // An error happened.
                        } else {
                            print("유저 삭제 성공")
                            // Account deleted.
                        }
                     }
                     */
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
            logOutSheet.addAction(cancel)
            logOutSheet.addAction(logOut)
            present(logOutSheet, animated: true, completion: nil)
        } else {
            present(networkAlert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {

        // 푸시 알림 허용 필요 알림
        allowPushAlert.addAction(allowPushAlertAction)

        // 네트워크 연결 실패 알림
        networkAlert.addAction(networkAlertAction)

        // Firebase Configure
        ref = Database.database().reference()
        
        super.viewDidLoad()

        // tableview 편집 버튼
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        // large title 사용 (only iOS 11)
        navigationController?.navigationBar.barStyle = .black
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus != .authorized) {
                data_center.notiOnOff = false
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "알림"
        case 1: return "사용자 키워드 모음"
        case 2: return "받아보는 공지사항 사이트"
        case 3: return "사용자 로그아웃"
        default: return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            if data_center.keyword.count != 0 {
                return data_center.keyword.count
            } else { // 키워드가 하나도 없을 때 방지
                return 1
            }
        case 2:
            return data_center.selectedWebsite.count + 1 // Add Button 까지 포함
        case 3:
            return 1
        default:
            print("Preference Table View error")
            return 0
        }
    }

    var noti_switch: UISwitch!

    // Push_notification 수신 설정
    @objc func noti_switchChanged(_ sender : UISwitch!){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized) {
                print("Push authorized")
                // 크게 감싸도 괜찮을까?
                DispatchQueue.main.async {
                    if connection { // 인터넷이 연결된 상태
                        if sender.isOn { // 스위치 켜짐
                            data_center.notiOnOff = true
                        }
                        else { // 스위치 꺼짐
                            data_center.notiOnOff = false
                        }
                        // Firebase에도 반영하기
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let uid = user.uid
                            let childUpdates = ["users/\(uid)/push_notification": data_center.notiOnOff]
                            ref.updateChildValues(childUpdates)
                        }
                    } else { // 인터넷이 연결되지 않은 상태
                        self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.none)
                        self.present(self.networkAlert, animated: true, completion: nil)
                    }
                }
            }
            else {
                print("Push not authorized")
                // 푸시 허용 필요 알림
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.none)
                    self.present(self.allowPushAlert, animated: true, completion: nil)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notiCell", for: indexPath)
            guard let notiCell = cell as? NotiCell else {
                return cell
            }
            notiCell.noti_cell_label.text = "푸시 알림 받기"
            notiCell.noti_cell_switch.isOn = data_center.notiOnOff
            notiCell.noti_cell_switch.addTarget(self, action: #selector(self.noti_switchChanged(_:)), for: .valueChanged)
            print("Section 1 리로드!!")
            return notiCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
            guard let keywordCell = cell as? KeywordCell else {
                return cell
            }
            if data_center.keyword.count == 0 {
                keywordCell.keyword_cell_label.text = "등록된 키워드가 없습니다."
            } else {
                keywordCell.keyword_cell_label.text = data_center.keyword[indexPath.row]
            }
            return keywordCell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedWebsiteCell", for: indexPath)
            guard let selectedWebsiteCell = cell as? SelectedWebsiteCell else {
                return cell
            }
            if indexPath.row < data_center.selectedWebsite.count {
                selectedWebsiteCell.selectedWebsite_cell_label.text = data_center.website[data_center.selectedWebsite[indexPath.row]]
                selectedWebsiteCell.addWebsite_cell_button.isHidden = true // 버튼 안보이기
            } else {
                selectedWebsiteCell.selectedWebsite_cell_label.text = ""
                selectedWebsiteCell.addWebsite_cell_button.isHidden = false
            }
            return selectedWebsiteCell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            guard let logoutCell = cell as? LogoutCell else {
                return cell
            }
            // 버튼 글자 크기 바꾸기
            // ...
            // 버튼 내 글자 바꾸기
            logoutCell.logout_cell_button_outlet.setTitle("로그아웃", for: .normal)

            return logoutCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notiCell", for: indexPath)
            print("Preference Table Cell error")
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 && data_center.keyword.count != 0{ // 키워드 모음만 편집 가능하도록
            return true
        }
        return false
    }

    // 슬라이드해서 키워드 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if connection { // 인터넷이 연결된 상태
            if data_center.keyword.count == 1 { // 키워드 하나 남았을 때 삭제하면
                data_center.keyword.remove(at: indexPath.row)
                self.tableView.reloadData() // cellForRowAt indexPath 다시 실행하기 위해서..
            } else {
                if editingStyle == UITableViewCell.EditingStyle.delete {
                    data_center.keyword.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            }
            // Firebase에도 반영하기
            let user = Auth.auth().currentUser
            if let user = user {
                print("키워드를 삭제했다고오ㅗ오?")
                let uid = user.uid
                let childUpdates = ["users/\(uid)/keywords": data_center.keyword]
                ref.updateChildValues(childUpdates)
            }
        } else { // 인터넷이 연결되지 않은 상태
            present(networkAlert, animated: true, completion: nil)
        }
    }

    // Override to support conditional editing of the table view.

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


//var allowPush:Bool = false
//@objc func noti_switchChanged(_ sender : UISwitch!){
//    let center = UNUserNotificationCenter.current()
//    center.getNotificationSettings { (settings) in
//        if(settings.authorizationStatus == .authorized) {
//            print("Push authorized")
//            self.allowPush = true
//        }
//        else {
//            print("Push not authorized")
//            // 푸시 허용 필요 알림
//            self.allowPush = false
//            DispatchQueue.main.async {
//                self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.none)
//            }
//            self.present(self.allowPushAlert, animated: true, completion: nil)
//        }
//    }
//    if allowPush {
//        if connection { // 인터넷이 연결된 상태
//            if sender.isOn { // 스위치 켜짐
//                data_center.notiOnOff = true
//            }
//            else { // 스위치 꺼짐
//                data_center.notiOnOff = false
//            }
//            // Firebase에도 반영하기
//            let user = Auth.auth().currentUser
//            if let user = user {
//                let uid = user.uid
//                let childUpdates = ["users/\(uid)/push_notification": data_center.notiOnOff]
//                ref.updateChildValues(childUpdates)
//            }
//        } else { // 인터넷이 연결되지 않은 상태
//            self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.none)
//            self.present(self.networkAlert, animated: true, completion: nil)
//        }
//    }
//    print(data_center.notiOnOff)
//}
