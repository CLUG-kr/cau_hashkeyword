//
//  WebsiteTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit
import Firebase

class WebsiteCell: UITableViewCell {
    @IBOutlet weak var website_cell_label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

class WebsiteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // 웹사이트 선택이 끝나고 돌아갈 때 Firebase에 선택한 웹사이트 업데이트
    // 근데 만약 웹사이트 선택하고 앱을 종료시켜버리면?
    // 그러므로 가장 확실한 방법은 아예 선택할 때마다 계속 업데이트하기. 느려지려나..?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            print("웹사이트 선택 끝났어요오오오")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data_center.website.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)
        guard let websiteCell = cell as? WebsiteCell else{
            return cell
        }
        for web in data_center.selectedWebsite {
            if web == indexPath.row {
                websiteCell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        websiteCell.website_cell_label.text = data_center.website[indexPath.row]
        return websiteCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        if let index = data_center.selectedWebsite.index(of: (indexPath.row)) {
            data_center.selectedWebsite.remove(at: index) // search해서 찾을 필요가 없음.
            cell?.setSelected(true, animated: true)
            cell?.setSelected(false, animated: false)
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            data_center.selectedWebsite.append(indexPath.row)
            cell?.setSelected(true, animated: true)
            cell?.setSelected(false, animated: false)
            cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        data_center.selectedWebsite.sort() // 오름차순으로 정렬해 놓기

        ref = Database.database().reference()
        let user = Auth.auth().currentUser // 리스너로 하면 다른 부분이랑 연동되는건지 앱 실행시 아래 부분이 수행된다. 그것도 여러 번 반복해서.. 왜 그럴까?
        if let user = user {
            let uid = user.uid
            var updateSelectedWebsite:[String] = []
            for index in data_center.selectedWebsite {
                updateSelectedWebsite.append(data_center.website[index])
            }
            let childUpdates = ["users/\(uid)/selectedWebsite": updateSelectedWebsite]
            ref.updateChildValues(childUpdates)
        }
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
