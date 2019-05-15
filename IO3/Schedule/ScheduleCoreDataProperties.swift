//
//  ScheduleCoreDataProperties.swift
//  IO3
//
//  Created by Christian C on 5/2/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import Foundation
import CoreData

extension Schedule {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var location: String?
    @NSManaged public var timeOfDay: Date?
    @NSManaged public var information: String?
    
}
