//
//  AudioFileCoreDataClass.swift
//  IO3
//
//  Created by Brian Hillis on 5/1/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//
import UIKit
import CoreData

@objc(AudioFile)
public class AudioFile: NSManagedObject {
	
	convenience init?(title: String, link: URL) {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		guard let managedContext = appDelegate?.persistentContainer.viewContext, title != "" else {
			return nil
		}
		self.init(entity: AudioFile.entity(), insertInto: managedContext)
		self.title = title
		self.link = link
	}
}
