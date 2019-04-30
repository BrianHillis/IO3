//
//  HomeViewController.swift
//  IO3
//
//  Created by Christian C on 4/1/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePicButton: UIButton!
    //projects array
    var projects = [String]()
    //description array
    var descriptions = [String]()
    //date array
    var dateStart = [String]()
    //day array
    var dayStart = [String]()
    
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load array data from ProjectListTableViewController into this view
        loadArray()
    }
    
    @IBAction func takePicFunc(_ sender: Any) {
       
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = imageView.image!
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory    fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
    
    
    func loadArray() {
        let viewControllerData = ProjectListTableViewController()
        projects = viewControllerData.projectDefaults.stringArray(forKey: "projectArray") ?? [String]()
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
                cell.projectLabel.text = projects[indexPath.row]
                cell.descriptionLabel.text = descriptions[indexPath.row]
                cell.dateLabel.text = dateStart[indexPath.row]
                cell.dayLabel.text = dayStart[indexPath.row]
            }
            return cell
        }
        
        return cell
        
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
