//
//  ProjectsCoreDataClass.swift
//  IO3
//
//  Created by Brian Hillis on 5/2/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

@objc(Project)
public class Project: NSManagedObject {
	
	convenience init?(title: String) {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		guard let managedContext = appDelegate?.persistentContainer.viewContext, title != "" else {
			return nil
		}
		self.init(entity: Project.entity(), insertInto: managedContext)
		self.title = title
	}
}
