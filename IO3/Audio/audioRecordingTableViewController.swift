//
//  audioRecordingTableViewController.swift
//  IO3
//
//  Created by Brian Hillis on 5/2/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class audioRecordingTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{

	@IBOutlet var audioRecordingTableView: UITableView!
	
	var audioFiles = [AudioFile]()
	
	var audioPlayer : AVAudioPlayer!
	var isPlaying = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		fetchAudioFiles()
		audioRecordingTableView.reloadData()
	}
	
	func fetchAudioFiles() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
//		let fetchRequestTest = NSFetchRequest<NSFetchRequestResult>(entityName: "AudioFile")
//		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // order results by category title ascending
		
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
//		if let notes = category.notes {
//			notesCount = notes.count
//		}
		cell.detailTextLabel?.text = audioFile.link?.absoluteString
		
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			deleteCategory(at: indexPath)
		}
	}
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let destination = segue.destination as? NotesViewController,
//			let row = categoriesTableView.indexPathForSelectedRow?.row{
//			destination.category = categories[row]
//		}
//	}
	
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
//			recordButton.isEnabled = true
//			playButton.setTitle("Play", for: .normal)
			isPlaying = false
		}
		else
		{
			if FileManager.default.fileExists(atPath: audioFiles[ind].link!.path)
			{
//				recordButton.isEnabled = false
//				playButton.setTitle("pause", for: .normal)
				prepare_play(i: ind)
				audioPlayer.play()
				isPlaying = true
			}
			else
			{
//				prepare_play(i: ind)
//				audioPlayer.play()
				print(audioFiles[ind].link?.path)
				print("Big error")
//				display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
				
			}
		}
	}
}
