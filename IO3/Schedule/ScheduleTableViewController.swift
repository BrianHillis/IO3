//
//  ScheduleTableViewController.swift
//  IO3
//
//  Created by Christian C on 4/4/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {
    
    //schedule array
    var schedules = [String]()
    var newSchedule: String  = ""
    
    var whereArray = [String]()
    var newWhere: String = ""
    
    //date/time array
    var dateTime = [Date]()
    var newDateTime: String = ""
    
    let scheduleDefaults = UserDefaults.standard
    let dateTimeDefaults = UserDefaults.standard
    let whereDefaults = UserDefaults.standard
    let noteDefaults = UserDefaults.standard
    
    @IBAction func cancel(segue:UIStoryboardSegue) {}
    @IBAction func done(segue:UIStoryboardSegue) {
    
    let AddScheduleVC = segue.source as! AddScheduleViewController
    newSchedule = AddScheduleVC.scheduleTitle
    newWhere = AddScheduleVC.whereString
    //newDateTime = AddScheduleVC.strDate
    
    //the concatString wont go to this viewController, so i cant add it to the cells. Christian please clutch up here my guy
        
    schedules.insert(newSchedule, at: 0)
    whereArray.insert(newWhere, at: 0)
    tableView.reloadData()
        
    scheduleDefaults.set(schedules, forKey: "scheduleArray")
    whereDefaults.set(whereArray, forKey: "whereArray")
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleDefaults.set(schedules, forKey: "scheduleArray")
        whereDefaults.set(whereArray, forKey: "whereArray")
        
        UIDatePicker.setValue(UIColor.orange, forKeyPath: "textColor")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        if let cell = cell as? ScheduleTableViewCell {
            //set row with data
            cell.scheduleLabel.text = schedules[indexPath.row]
            cell.whereWhenLabel.text = descriptions[indexPath.row]
            cell.dateLabel.text = dateStart[indexPath.row]
            cell.dayLabel.text = dayStart[indexPath.row]
        }
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
