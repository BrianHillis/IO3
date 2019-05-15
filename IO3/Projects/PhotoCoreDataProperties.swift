//
//  PhotoCoreDataProperties.swift
//  IO3
//
//  Created by Brian Hillis on 5/14/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
		return NSFetchRequest<Photo>(entityName: "Photo")
	}
	
	@NSManaged public var filePath: String?
	@NSManaged public var placement: String?
	
}
