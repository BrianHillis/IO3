//
//  ProjectListTableViewController.swift
//  IO3
//
//  Created by Christian C on 3/28/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

class ProjectListTableViewController: UITableViewController {
    //projects array
	var projects = [Project]()
	
	
//    var projects = [String]()
    var newProject: String  = ""
    //description array
    var descriptions = [String]()
    var newDescription: String  = ""
    //date array
    var dateStart = [String]()
    var newDate: String  = ""
    //day array
    var dayStart = [String]()
    var newDay: String = ""
    
    //initialize local storage data sets
    let projectDefaults = UserDefaults.standard
    let descriptionDefaults = UserDefaults.standard
    let dateDefaults = UserDefaults.standard
    let dayDefaults = UserDefaults.standard
    
    @IBAction func cancel(segue:UIStoryboardSegue) {}
    @IBAction func done(segue:UIStoryboardSegue) {
        
        
        
        //load data gained from AddProjectViewController
        let AddProjectVC = segue.source as! AddProjectViewController
        newProject = AddProjectVC.projectTitle
        newDescription = AddProjectVC.descriptionInput
        newDate = AddProjectVC.dateString
        newDay = AddProjectVC.dayString
        
        //insert data at the front of the array
//        projects.insert(newProject, at: 0)
        descriptions.insert(newDescription, at: 0)
        dateStart.insert(newDate, at: 0)
        dayStart.insert(newDay, at: 0)
		
		autoSave()
		
        tableView.reloadData()
        
        //set local storage
//        projectDefaults.set(projects, forKey: "projectArray")
        descriptionDefaults.set(descriptions, forKey: "descriptionArray")
        dateDefaults.set(dateStart, forKey: "dateArray")
        dayDefaults.set(dayStart, forKey: "dayArray")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		fetchProjects()
        
        //load data from local storage
//        projects = projectDefaults.stringArray(forKey: "projectArray") ?? [String]()
        descriptions = descriptionDefaults.stringArray(forKey: "descriptionArray") ?? [String]()
        dateStart = dateDefaults.stringArray(forKey: "dateArray") ?? [String]()
        dayStart = dateDefaults.stringArray(forKey: "dayArray") ?? [String]()
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)

        if let cell = cell as? ProjectListTableViewCell {
            //set row with data
            cell.projectLabel.text = projects[indexPath.row].title
            cell.descriptionLabel.text = projects[indexPath.row].info
            cell.dateLabel.text = projects[indexPath.row].date
            cell.dayLabel.text = projects[indexPath.row].day
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //remove data from row
//            projects.remove(at: indexPath.row)
//            descriptions.remove(at: indexPath.row)
//            dateStart.remove(at: indexPath.row)
//            dayStart.remove(at: indexPath.row)
//            //update local storage
////            projectDefaults.set(projects, forKey: "projectArray")
//            descriptionDefaults.set(descriptions, forKey: "descriptionArray")
//            dateDefaults.set(dateStart, forKey: "dateArray")
//            dayDefaults.set(dayStart, forKey: "dayArray")
//            //physically remove row
//            tableView.deleteRows(at: [indexPath], with: .fade)
			deleteData(i: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
	
	func fetchProjects() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
		//		let fetchRequestTest = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioFile")
		//		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // order results by category title ascending
		
		do {
			projects = try managedContext.fetch(fetchRequest)
		} catch {
			//alertNotifyUser(message: "Fetch for audio files could not be performed.")
			return
		}
		print(projects.count)
	}
	
	func autoSave(){
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let projectEntity = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)!
		let project = NSManagedObject(entity: projectEntity, insertInto: managedContext)
		project.setValue(newProject, forKey: "title")
		project.setValue(newDate, forKey: "date")
		project.setValue(newDay, forKey: "day")
		project.setValue(newDescription, forKey: "info")
		projects.append(project as! Project)
		//		print(files[0].title!)
		//		print(files[0].link!)
		
		for Project in projects{
			print(Project.title!)
		}
		
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
		let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
		do{
			let proj = try managedContext.fetch(fetchRequest)
			
			let goodbye = proj[i] as NSManagedObject
			managedContext.delete(goodbye)
			
			do{
				try managedContext.save()
			}
			catch{
				print("oh no")
			}
		}
		catch{
			print("rats")
		}
		tableView.reloadData()
	}

    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
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
