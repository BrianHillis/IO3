//
//  PhotoCoreDataClass.swift
//  IO3
//
//  Created by Brian Hillis on 5/14/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
	
	convenience init?(filePath: String, placement: String) {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		guard let managedContext = appDelegate?.persistentContainer.viewContext, filePath != "" else {
			return nil
		}
		self.init(entity: Photo.entity(), insertInto: managedContext)
		self.filePath = filePath
		self.placement = placement
	}
}
