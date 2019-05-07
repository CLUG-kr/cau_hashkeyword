//
//  WebsiteTableViewController.swift
//  CAU_hashkeyword_IOS_application
//
//  Created by Tars on 2/20/19.
//  Copyright © 2019 Changsung Lim. All rights reserved.
//

import UIKit

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
            data_center.selectedWebsite.remove(at: index)
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
