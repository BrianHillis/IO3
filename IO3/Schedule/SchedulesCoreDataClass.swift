//
//  SchedulesCoreDataClass.swift
//  IO3
//
//  Created by Christian C on 5/2/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

@objc(Schedule)
public class Schedule: NSManagedObject {
    
    convenience init?(title: String, location: String, when: Date, note: String ) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext, title != "" else {
            return nil
        }
        self.init(entity: Schedule.entity(), insertInto: managedContext)
        self.title = title
        self.location = location
        self.timeOfDay = when
        self.information = note
    }
}
