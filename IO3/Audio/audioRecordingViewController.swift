//
//  audioRecordingViewController.swift
//  audioRecordingTest
//
//  Created by Brian Hillis on 3/28/19.
//  Copyright © 2019 Brian Hillis. All rights reserved.
//
// https://stackoverflow.com/questions/26472747/recording-audio-in-swift

import UIKit
import AVFoundation
import CoreData

class audioRecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
	
	@IBOutlet weak var recordingTimeLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var textOutlet: UITextField!
	
	@IBOutlet weak var saveButton: UIButton!
	
	var audioRecorder: AVAudioRecorder!
	var audioPlayer : AVAudioPlayer!
	var meterTimer:Timer!
	var isAudioRecordingGranted: Bool!
	var isRecording = false
	var isPlaying = false
	
	var fileTitle:String!
	
	var fileName:String!
	
	var count = 0
	
	var audioFiles = [URL]()
	
	var files = [AudioFile]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkPermissions();
		fetchAudioFiles()
		count = files.count
	}
	
	func checkPermissions(){
		switch AVAudioSession.sharedInstance().recordPermission {
		case AVAudioSessionRecordPermission.granted:
			isAudioRecordingGranted = true
			break
		case AVAudioSessionRecordPermission.denied:
			isAudioRecordingGranted = false
			break
		case AVAudioSessionRecordPermission.undetermined:
			AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
				if allowed {
					self.isAudioRecordingGranted = true
				} else {
					self.isAudioRecordingGranted = false
				}
			})
			break
		default:
			break
		}
	}

	func getDocumentsDirectory() -> URL
	{
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	func getFileUrl() -> URL
	{
		count = files.count
		let filename = "myRecording\(count).m4a"
		let filePath = getDocumentsDirectory().appendingPathComponent(filename)
		return filePath
	}
	
	func setup_recorder()
	{
		if isAudioRecordingGranted
		{
			let session = AVAudioSession.sharedInstance()
			do
			{
				try session.setCategory(.playAndRecord, mode: .default)
				try session.setActive(true)
				let settings = [
					AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
					AVSampleRateKey: 44100,
					AVNumberOfChannelsKey: 2,
					AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
				]
				audioRecorder = try AVAudioRecorder(url: getFileUrl (), settings: settings)
				audioRecorder.delegate = self
				audioRecorder.isMeteringEnabled = true
				audioRecorder.prepareToRecord()
			}
			catch let error {
				display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
			
			}
		}
		else
		{
			display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
			
		}
	}
	
	@IBAction func startRecording(_ sender: UIButton) {
	
		if(isRecording)
		{
			finishAudioRecording(success: true)
			recordButton.setTitle("Record", for: .normal)
			playButton.isEnabled = true
			isRecording = false
		}
		else
		{
			setup_recorder()
			audioRecorder.record()
			meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
			recordButton.setTitle("Stop", for: .normal)
			playButton.isEnabled = false
			isRecording = true
		}
	}
	
	@objc func updateAudioMeter(timer: Timer)
	{
		if audioRecorder.isRecording
		{
			let hr = Int((audioRecorder.currentTime / 60) / 60)
			let min = Int(audioRecorder.currentTime / 60)
			let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
			let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
			recordingTimeLabel.text = totalTimeString
			audioRecorder.updateMeters()
		}
	}
	
	func finishAudioRecording(success: Bool)
	{
		if success
		{
			audioRecorder.stop()
			audioRecorder = nil
			meterTimer.invalidate()
			let alert = UIAlertController(title: "Would you like to save this audio clip?", message: "", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {  action in
				self.audioFiles.append(self.getFileUrl())
				if let name = alert.textFields?.first?.text {
				print("Your audio clip name: \(name)")
					self.autoSave(name: name)
				}
				self.count+=1
			}))
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			alert.addTextField(configurationHandler: {textField in
				textField.placeholder = "Give your audio clip a name..."
			})
			fileName = alert.textFields?.first?.text
			self.present(alert, animated: true)
		}

		else
		{
			display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
		
		}
	}
	
	func prepare_play()
	{
		do
		{
			audioPlayer = try AVAudioPlayer(contentsOf: files[files.count-1].link!)
			audioPlayer.delegate = self
			audioPlayer.prepareToPlay()
		}
		catch{
			print("Error4")
		}
	}
	
	@IBAction func playRecording(_ sender: UIButton) {
		if(isPlaying)
		{
			audioPlayer.stop()
			recordButton.isEnabled = true
			playButton.setTitle("Play", for: .normal)
			isPlaying = false
		}
		else
		{
			if FileManager.default.fileExists(atPath: files[files.count-1].link!.path)
			{
				recordButton.isEnabled = false
				playButton.setTitle("pause", for: .normal)
				prepare_play()
				audioPlayer.play()
				isPlaying = true
			}
			else
			{
				display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
			
			}
		}
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
	{
		if !flag
		{
			finishAudioRecording(success: false)
		}
		playButton.isEnabled = true
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
	{
		recordButton.isEnabled = true
		isPlaying=false
		playButton.setTitle("Play", for: .normal)
	}
	
	func display_alert(msg_title : String , msg_desc : String ,action_title : String)
	{
		let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: action_title, style: .default)
		{
			(result : UIAlertAction) -> Void in
			_ = self.navigationController?.popViewController(animated: true)
		})
		present(ac, animated: true)
	}
	
	@IBAction func saveFile(_ sender: Any) {
		
		fileTitle = textOutlet.text
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fileEntity = NSEntityDescription.entity(forEntityName: "AudioFile", in: managedContext)!
		let file = NSManagedObject(entity: fileEntity, insertInto: managedContext)
		file.setValue(fileTitle, forKey: "title")
		file.setValue(getFileUrl(), forKey: "link")
		files.append(file as! AudioFile)
		
		do{
			try managedContext.save()
		}
		catch let error as NSError{
			print("Couldn't save \(error)")
		}
	}
	
	func autoSave(name: String){
		
		fileTitle = name
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fileEntity = NSEntityDescription.entity(forEntityName: "AudioFile", in: managedContext)!
		let file = NSManagedObject(entity: fileEntity, insertInto: managedContext)
		file.setValue(fileTitle, forKey: "title")
		file.setValue(getFileUrl(), forKey: "link")
		files.append(file as! AudioFile)
		do{
			try managedContext.save()
		}
		catch let error as NSError{
			print("Couldn't save \(error)")
		}
	}
	
	func fetchAudioFiles() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
		
		do {
			files = try managedContext.fetch(fetchRequest)
		} catch {
			return
		}
	}
}

