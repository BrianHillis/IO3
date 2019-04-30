//
//  AddScheduleViewController.swift
//  IO3
//
//  Created by Christian C on 4/4/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class AddScheduleViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    var scheduleTitle: String = ""
    var noteInput: String = ""
    var whenString: String = ""
    var whereString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSSegue" {
            scheduleTitle = nameTextField.text!
            whereString = whereTextField.text!
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            
            let strDate = dateFormatter.string(from: datePicker.date)
            //need to concat the where @ when
            let concatString = whereString + " at " + strDate
            
            
        }
        if segue.identifier == "cancelSSegue"{
            return
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
