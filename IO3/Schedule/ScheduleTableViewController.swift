//
//  ScheduleTableViewController.swift
//  IO3
//
//  Created by Christian C on 4/4/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {
    
    //schedule array
    var schedules = [Schedule]()
    
    var scheduleTitle:String!
    var scheduleLocation:String!
    var scheduleWhen:Date!
    var scheduleNote:String!
    struct globalVariable{
        static var nextTitle = String()
        static var nextTime = Date()
        static var nextWhere = String()
        static var nextNote = String()
    }
    
    @IBAction func cancelSchedule(segue: UIStoryboardSegue) {}
    @IBAction func doneWithSchedule(segue: UIStoryboardSegue) {

        //load data gained from AddScheduleViewController
        let AddScheduleVC = segue.source as! AddScheduleViewController
        scheduleTitle = AddScheduleVC.scheduleTitle
        scheduleLocation = AddScheduleVC.scheduleLocation
        scheduleWhen = AddScheduleVC.scheduleTime
        scheduleNote = AddScheduleVC.scheduleNotes
        

        autoSave()
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSchedules()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(schedules.count)
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        if let cell = cell as? ScheduleTableViewCell {
            //set row with data
            cell.scheduleTitleLabel.text = schedules[indexPath.row].title
            cell.timeLocationLabel.text = schedules[indexPath.row].location
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteData(i: indexPath.row)
            fetchSchedules()
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func fetchSchedules() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        
        do {
            schedules = try managedContext.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func autoSave(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let scheduleEntity = NSEntityDescription.entity(forEntityName: "Schedule", in: managedContext)!
        let schedule = NSManagedObject(entity: scheduleEntity, insertInto: managedContext)
        schedule.setValue(scheduleTitle, forKey: "title")
        schedule.setValue(scheduleLocation, forKey: "location")
        schedule.setValue(scheduleNote, forKey: "information")
        schedule.setValue(scheduleWhen, forKey: "timeOfDay")
        schedules.append(schedule as! Schedule)
        
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print("Couldn't save \(error)")
        }
    }
    
    func deleteData(i: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        do{
            let proj = try managedContext.fetch(fetchRequest)
            print(proj)
            let goodbye = proj[i] as NSManagedObject
            managedContext.delete(goodbye)
            
            do{
                try managedContext.save()
            }
            catch{
                print("catch 1")
            }
        }
        catch{
            print("catch 2")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = schedules[indexPath.row]
        globalVariable.nextTitle = schedule.title!
        globalVariable.nextTime = schedule.timeOfDay!
        globalVariable.nextWhere = schedule.location!
        globalVariable.nextNote = schedule.information!
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
//
////        if let cell = cell as? ProjectListTableViewCell {
//            //set row with data
////            cell.projectLabel.text = projects[indexPath.row].title
////            cell.descriptionLabel.text = projects[indexPath.row].info
////            cell.dateLabel.text = projects[indexPath.row].date
////            cell.dayLabel.text = projects[indexPath.row].day
//        }
//
//        return cell
//    }
 

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
