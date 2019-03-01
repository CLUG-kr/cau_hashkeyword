//
//  PreferenceTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Hyeseong Kim. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {

    @IBOutlet weak var alert_cell_label: UILabel!
    @IBOutlet weak var alert_cell_switch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

class PreferenceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview 편집 버튼
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        navigationController?.navigationBar.barStyle = .black
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "알림"
        case 1: return "사용자 키워드 모음"
        case 2: return "받아보는 공지사항 사이트"
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
            return data_center.selectedWebsite.count + 1// Add Button 까지 포함
        default:
            print("Preference Table View error")
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)
            guard let alertCell = cell as? AlertCell else {
                return cell
            }
            alertCell.alert_cell_label.text = "키워드 발견 시 알림"
            return alertCell
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)
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
        if data_center.keyword.count == 1 { // 키워드 하나 남았을 때 삭제하면
            data_center.keyword.remove(at: indexPath.row)
            self.tableView.reloadData() // cellForRowAt indexPath 다시 실행하기 위해서..
        } else {
            if editingStyle == UITableViewCell.EditingStyle.delete {
                data_center.keyword.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
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
