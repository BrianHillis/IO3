//
//  AddScheduleViewController.swift
//  IO3
//
//  Created by Christian C on 4/4/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var whenDatePicker: UIDatePicker!
    
    var scheduleTitle: String = ""
    var scheduleLocation: String = ""
    var scheduleNotes: String = ""
    var scheduleTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whenDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneWithSchedule" {
            scheduleTitle = titleTextField.text!
            scheduleLocation = locationTextField.text!
            scheduleNotes = notesTextField.text!
            scheduleTime = getScheduleTime()
        }
        if segue.identifier == "cancelSchedule"{
            return
        }
    }
    
    func getScheduleTime() -> Date{
        let thisTime = whenDatePicker.date
        return thisTime
    }
    

}
