//
//  ArchiveTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
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
        // 키보드
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap) // 제스처 인식
    }

    func setupNavBar() {
        // title 과 status bar 흰색으로 설정
        navigationController?.navigationBar.barStyle = .black
        // large title 사용 (only iOS 11?)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        // 검색
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data_center.cau.cau_title.count
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

        var reference:String
        reference = "중앙대학교"

        infoCell.cell_title.text = data_center.cau.cau_title[indexPath.row]

        infoCell.cell_detail.text = reference + " #" + data_center.keyword[1]
        // 키워드 색깔만 파란색으로 설정
        let attributedStr = NSMutableAttributedString(string: infoCell.cell_detail.text!)
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor().colorFromHex("0E58F9"), range: NSRange(location:reference.count, length:data_center.keyword[1].count + 2))
        infoCell.cell_detail.attributedText = attributedStr

        infoCell.cell_date.text = data_center.cau.cau_date[indexPath.row]

        return infoCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNotice(data_center.cau.cau_url[indexPath.row]) // SFSafariViewController 띄우기
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
