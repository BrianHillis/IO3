//
//  HomeViewController.swift
//  IO3
//
//  Created by Christian C on 4/1/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var audioButton: UIButton!
	
    //projects array
    var projects = [Project]()
    //description array
    var descriptions = [String]()
    //date array
    var dateStart = [String]()
    //day array
    var dayStart = [String]()
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load array data from ProjectListTableViewController into this view
//        loadArray()
		fetchProjects()
		tableView.reloadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		fetchProjects()
		tableView.reloadData()
	}
    
    func loadArray() {
        let viewControllerData = ProjectListTableViewController()
//        projects = viewControllerData.projectDefaults.stringArray(forKey: "projectArray") ?? [String]()
        descriptions = viewControllerData.descriptionDefaults.stringArray(forKey: "descriptionArray") ?? [String]()
        dateStart = viewControllerData.dateDefaults.stringArray(forKey: "dateArray") ?? [String]()
        dayStart = viewControllerData.dateDefaults.stringArray(forKey: "dayArray") ?? [String]()
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(projects.count >= 2){
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath)
        
        if(projects.count == 0){
            if let cell = cell as? HomeTableViewCell{
                cell.projectLabel.text = "No project created yet!"
                cell.descriptionLabel.text = "Add one in the Projects tab"
                cell.dateLabel.text = ""
                cell.dayLabel.text = ""
            }
            return cell
        }
        
        if(projects.count >= 1){
            if let cell = cell as? HomeTableViewCell{
                cell.projectLabel.text = projects[indexPath.row].title
                cell.descriptionLabel.text = projects[indexPath.row].info
                cell.dateLabel.text = projects[indexPath.row].date
                cell.dayLabel.text = projects[indexPath.row].day
            }
            return cell
        }
        
        return cell
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
