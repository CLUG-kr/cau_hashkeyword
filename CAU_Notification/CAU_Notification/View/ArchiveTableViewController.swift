//
//  ArchiveTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import SafariServices // SFSafariViewController 사용

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

        // 임시용
        for title in data_center.dorm.dorm_title {
            data_center.timeline.append(Timeline(title: title, ref: "레퍼런스", date: "YYYY.MM.DD"))
        }
    }

    // 검색 (available only in iOS 8+)
    let searchController = UISearchController(searchResultsController: nil)

    func setupNavBar() {
        // title 과 status bar 흰색으로 설정
        navigationController?.navigationBar.barStyle = .black
        // large title 사용 (only iOS 11?)
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

    /*
    // 화면에 noData를 띄울지 결정.
    override func numberOfSections(in tableView: UITableView) -> Int {
        if dataCenter.studyList.count != 0 {
            tableView.backgroundView = nil
            // tableView.backgroundColor = UIColor().colorFromHex("#4C516D")
        }
        else {
            tableView.backgroundView = noDataView
        }
        return dataCenter.studyList.count
    }
    */

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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

        let data: Timeline
        if isFiltering() {
            data = filteredData[indexPath.row]
        } else {
            data = data_center.timeline[indexPath.row]
        }

        infoCell.cell_title.text = data.title
        // infoCell.cell_title.text = data_center.dorm.dorm_title[indexPath.row]
        infoCell.cell_detail.text = data_center.timeline[indexPath.row].ref + " #" + data_center.keyword[1]

        // 키워드 색깔만 파란색으로 설정
        let attributedStr = NSMutableAttributedString(string: infoCell.cell_detail.text!)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor().colorFromHex("0E58F9"), range: NSRange(location:data_center.timeline[indexPath.row].ref.count, length:data_center.keyword[1].count + 2))
        infoCell.cell_detail.attributedText = attributedStr

        infoCell.cell_date.text = data_center.timeline[indexPath.row].date

        return infoCell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNotice(data_center.dorm.dorm_url[indexPath.row]) // SFSafariViewController 띄우기
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

extension ArchiveTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
