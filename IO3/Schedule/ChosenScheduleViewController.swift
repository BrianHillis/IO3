//
//  ChosenScheduleViewController.swift
//  IO3
//
//  Created by Christian C on 5/12/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit
import CoreData

class ChosenScheduleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var schedules = [Schedule()]
    var indexHere:Int!
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "MM-dd-yyyy ',' hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dateString = dateFormatter.string(from: ScheduleTableViewController.globalVariable.nextTime)
        
        titleLabel.text = ScheduleTableViewController.globalVariable.nextTitle
        locationLabel.text = ScheduleTableViewController.globalVariable.nextWhere
        timeLabel.text = dateString
        noteLabel.text = ScheduleTableViewController.globalVariable.nextNote
        //titleLabel.text = schedules[ScheduleTableViewController.globalVariable.index].title
    }
    
}
