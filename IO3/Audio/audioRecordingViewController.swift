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

class audioRecordingViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate { //make sure to add these 2 things
	
	@IBOutlet weak var recordingTimeLabel: UILabel! //link the label and both buttons with outlets
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
//	@IBOutlet weak var playbackSlider: UISlider!
	
	var audioRecorder: AVAudioRecorder! //declare some variables to be used later on
	var audioPlayer : AVAudioPlayer!
	var meterTimer:Timer!
	var isAudioRecordingGranted: Bool!
	var isRecording = false
	var isPlaying = false
	
//	var project = Project?
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkPermissions();
	}
	
	func checkPermissions(){
		switch AVAudioSession.sharedInstance().recordPermission { //made a correction here to make xcode happy
		case AVAudioSessionRecordPermission.granted: //this code came from the stack overflow
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
	
	
	
	func getDocumentsDirectory() -> URL //these 2 functions get the path for saving the audio recording
	{
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	func getFileUrl() -> URL
	{
//		let filename = project.name //change this to change the name of the saved file
//		project.filePath = getDocumentsDirectory().appendingPathComponent(filename)
//		print(project.filePath)
//		return project.filePath
		let filename = "myRecording.m4a"
		let filePath = getDocumentsDirectory().appendingPathComponent(filename)
		return filePath
	}
	
	
	
	func setup_recorder() //set up the recorder, code is from stack overflow
	{
		print("test")
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
	@IBAction func startRecording(_ sender: UIButton) { //IBaction from the right button to start recording
	
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
			print("recorded successfully.")
			
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
			audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
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
			if FileManager.default.fileExists(atPath: getFileUrl().path)
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
		playButton.setTitle("Play", for: .normal) //added to test switching buttons
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
	

}

