//
//  AudioFileCoreDataProperties.swift
//  IO3
//
//  Created by Brian Hillis on 5/1/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import Foundation
import CoreData


extension AudioFile {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<AudioFile> {
		return NSFetchRequest<AudioFile>(entityName: "AudioFile")
	}
	
	@NSManaged public var title: String?
	@NSManaged public var link: URL?
	
}
