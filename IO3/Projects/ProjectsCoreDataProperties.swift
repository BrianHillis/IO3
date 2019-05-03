//
//  ProjectsCoreDataProperties.swift
//  IO3
//
//  Created by Brian Hillis on 5/2/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import Foundation
import CoreData


extension Project {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
		return NSFetchRequest<Project>(entityName: "Project")
	}
	
	@NSManaged public var title: String?
	@NSManaged public var date: String?
	@NSManaged public var day: String?
	@NSManaged public var info: String?
	
}
