//
//  SingleProjectTableViewController.swift
//  IO3
//
//  Created by Jason Tesreau on 5/7/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreData

class SingleProjectTableViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var audioRecordingTableView: UITableView!
	
	@IBOutlet weak var projectTitleOutlet: UILabel!
	
	@IBOutlet weak var dateCreatedOutlet: UILabel!
	
	@IBOutlet weak var descriptionOutlet: UILabel!
	
	@IBOutlet weak var audioButton: UIButton!
	
	var audioFiles = [AudioFile]()
	var projects = [Project]()
    
    var audioPlayer : AVAudioPlayer!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		audioButton.layer.cornerRadius = 5
		audioButton.layer.borderWidth = 1
		audioButton.layer.borderColor = UIColor.green.cgColor
		
    }
    
    @IBAction func viewPhotosFunc(_ sender: Any) {
        
    
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAudioFiles()
		fetchProjects()
        audioRecordingTableView.reloadData()
		loadData()
    }
    
    func fetchAudioFiles() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
        //        let fetchRequestTest = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioFile")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // order results by category title ascending
        
        do {
            audioFiles = try managedContext.fetch(fetchRequest) as! [AudioFile]
        } catch {
            alertNotifyUser(message: "Fetch for audio files could not be performed.")
            return
        }
        print(audioFiles.count)
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioRecordingCell", for: indexPath)
        
        let audioFile = audioFiles[indexPath.row]
        cell.textLabel?.text = audioFile.title
        //        if let notes = category.notes {
        //            notesCount = notes.count
        //        }
        cell.detailTextLabel?.text = audioFile.link?.absoluteString
        cell.textLabel?.textColor = UIColor.green
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategory(at: indexPath)
        }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let destination = segue.destination as? NotesViewController,
    //            let row = categoriesTableView.indexPathForSelectedRow?.row{
    //            destination.category = categories[row]
    //        }
    //    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let audioFile = audioFiles[indexPath.row]
        
        if let managedObjectContext = audioFile.managedObjectContext {
            managedObjectContext.delete(audioFile)
            
            do {
                try managedObjectContext.save()
                self.audioFiles.remove(at: indexPath.row)
                audioRecordingTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete of audio file failed.")
                audioRecordingTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("section: \(indexPath.section)")
        playRecording(ind: indexPath.row)
        print("row: \(indexPath.row)")
        print(audioFiles[indexPath.row].link!.path)
    }
    
    func prepare_play(i: Int)
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFiles[i].link!)
            audioPlayer.delegate = self as AVAudioPlayerDelegate
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error4")
        }
    }
    
    func playRecording(ind: Int) {
        if(isPlaying)
        {
            audioPlayer.stop()
            //            recordButton.isEnabled = true
            //            playButton.setTitle("Play", for: .normal)
            isPlaying = false
        }
        else
        {
            if FileManager.default.fileExists(atPath: audioFiles[ind].link!.path)
            {
                //                recordButton.isEnabled = false
                //                playButton.setTitle("pause", for: .normal)
                prepare_play(i: ind)
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                //                prepare_play(i: ind)
                //                audioPlayer.play()
                print(audioFiles[ind].link?.path)
                print("Big error")
                //                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
                
            }
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
	
	func loadData(){
		projectTitleOutlet.text = ProjectListTableViewController.globalVariable.nextTitle
		dateCreatedOutlet.text = ProjectListTableViewController.globalVariable.nextDate
//		timeLabel.text = dateString
		descriptionOutlet.text = ProjectListTableViewController.globalVariable.nextDescription
	}
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//
//    
//    @IBOutlet weak var picsCollectionView: UICollectionView!
//    @IBOutlet weak var collectionViewCell: UICollectionViewCell!
//    @IBOutlet weak var imageView: UIImageView!
//    
//    
//    var selectedImage = UIImage ()
//    @IBAction func selectPicsFunc(_ sender: Any) {
//        
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        
//        if self.picsCollectionView.isHidden == true
//        {
//            self.picsCollectionView.isHidden = false
//            self.imageView.isHidden = true
//        }
//        
//        self.picker.allowsEditing = true
//        self.picker.sourceType = .photoLibrary
//        present(self.picker, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String: Any])
//    {
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
//        {
//            selectedImage = image
//            self.picsCollectionView.reloadData()
//        }
//        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        {
//            selectedImage = image
//            self.picsCollectionView.reloadData()
//        }
//        else
//        {
//            print("Something went wrong")
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! UploadCollectionViewCell
//        
//        cell.cellImgView.image = selectedImage
//        
//        return cell
//    }
    






//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//    /*
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
//    */

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


