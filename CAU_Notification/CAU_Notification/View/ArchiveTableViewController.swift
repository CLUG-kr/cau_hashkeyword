//
//  ArchiveTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import SafariServices // SFSafariViewController 사용
import Firebase

class ArchiveTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_detail: UILabel!
    @IBOutlet weak var cell_date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class ArchiveTableViewController: UITableViewController {

    @IBOutlet var no_data_view: UIView!

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션 바
        setupNavBar()
    }

    func getRefFromURL(_ url:String) -> String{
        let refer = url.components(separatedBy: "//")[1].components(separatedBy: ".")[0]
        for web in data_center.website { // 웹사이트가 추가되어도 DataCenter만 수정해주면 된다. (유지보수가 쉬움)
            let parseWeb = web.components(separatedBy: "(")[1].components(separatedBy: ".")[0]
            var newRefer = web.components(separatedBy: " ")[0]

            // "서울캠퍼스", "안성캠퍼스" 길이가 길어서 TimeLine이 깔끔하지 않으니, 각각 "(서울)", "(안성)"으로 대체
            if newRefer == "서울캠퍼스" {
                newRefer = "(서울)" + web.components(separatedBy: " ")[1]
            }
            else if newRefer == "안성캠퍼스" {
                newRefer = "(안성)" + web.components(separatedBy: " ")[1]
            }
            else {
                newRefer = web.components(separatedBy: " ")[0]
            }
            if refer == parseWeb {
                return newRefer
            }
        }
        return "공지사항" // 만약 일치하는 사이트가 없다면 default로 return

//        switch refer { // 미래에 새로운 웹사이트가 생기면 케이스 추가가 필요한 코드 (유지보수 어려움)
//            case "cau":
//            case "libary":
//            case "dormitory":
//            case "ict":
//            case "cse":
//        }
    }

    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
            // .value는 항상 호출되고 .childChanged는 항상 호출되지 않는 상태...
            databaseHandle = ref?.child("users/\(user.uid)/pushData").observe(.value) { (snapshot) in
                // Code to execute when a child is changed under "users/uid"
                // Take the value from the snapshot and added it to the timeline array
                var flag = true
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let pushData = snap.value as! [String]
                    // firebase DB에 있는 pushData가 app에 없는 데이터인지 확인
                    if data_center.timeline.count > 0 {
                        
                        // firebase DB가 매번 새로운 것으로 갈아치우지 않는다면 에러가 날 수도 있는 부분..
                        if pushData[1] == data_center.timeline[0].title { // Fatal error: Index out of range
                            flag = false
                            break
                        }
                    } else {
                        break
                    }
                }
                if flag {
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let pushData = snap.value as! [String]
                        let reference = self.getRefFromURL(pushData[3])
                        data_center.timeline.insert(Timeline(keyword: pushData[0], title: pushData[1], ref: reference, date: pushData[2], url: pushData[3]), at: 0)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }

    // 검색 (available only in iOS 8+)
    let searchController = UISearchController(searchResultsController: nil)

    func setupNavBar() {
        // title 과 status bar 흰색으로 설정
        navigationController?.navigationBar.barStyle = .black
        // large title 사용 (only iOS 11)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        // 네비게이션 바에 서치바 추가
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // 서치바 디자인 구성
        searchController.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // 검색 기능
        searchController.obscuresBackgroundDuringPresentation = false // 검색 시 새로운 뷰에 표현하지 않음
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    // status bar 색깔 흰색으로 기본 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // 검색 결과에 표시할 데이터를 담는 공간
    var filteredData = [Timeline]()

    // SearchController
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredData = data_center.timeline.filter({( data : Timeline) -> Bool in
            // Cell에 있는 내용 모두 검사하기
            // 제목, 출처, 날짜 등으로 모두 검색할 수 있다
            if (data.title.lowercased().contains(searchText.lowercased()) || data.ref.lowercased().contains(searchText.lowercased()) || data.date.lowercased().contains(searchText.lowercased())) {
                return true
            } else {
                return false
            }
        })
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 화면에 noData를 띄울지 결정.
        if data_center.timeline.count != 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            // tableView.backgroundColor = UIColor().colorFromHex("#4C516D")
            return 1
        }
        else {
            tableView.separatorStyle = .none
            tableView.backgroundView = no_data_view
            return 0
        }
    }

    // 검색 기능을 위함
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredData.count
        }
        return data_center.timeline.count
    }

    // 셀의 Row 값 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;
    }

    func showNotice(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        guard let infoCell = cell as? ArchiveTableViewCell else{
            return cell
        }

        // 검색을 하고 있는 지에 따라 테이블 뷰에 표현할 데이터를 정의
        let data:Timeline
        if isFiltering() {
            data = filteredData[indexPath.row]
        } else {
            data = data_center.timeline[indexPath.row]
        }

        infoCell.cell_title.text = data.title
        infoCell.cell_detail.text = data.ref + " #" + data.keyword

        // 키워드 색깔만 파란색으로 설정
        let attributedStr = NSMutableAttributedString(string: infoCell.cell_detail.text!)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor().colorFromHex("0E58F9"), range: NSRange(location:data.ref.count, length:data.keyword.count + 2))
        infoCell.cell_detail.attributedText = attributedStr

        infoCell.cell_date.text = data.date

        return infoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url:String
        if isFiltering() { // 검색한 항목을 선택해 연결한 경우를 구분
            url = filteredData[indexPath.row].url
        } else {
            url = data_center.timeline[indexPath.row].url
        }
        showNotice(url) // SFSafariViewController 띄우기
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

// SearchController를 위한 Update 확장 기능
extension ArchiveTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
