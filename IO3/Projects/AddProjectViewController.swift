//
//  AddProjectViewController.swift
//  IO3
//
//  Created by Christian C on 3/28/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var projectTitle: String = ""
    var descriptionInput: String = ""
    var dateString: String = ""
    var dayString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            projectTitle = titleTextField.text!
            descriptionInput = descriptionTextField.text!
            
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = dateFormatter.string(from: now)
            dateString = nameOfMonth
            dateFormatter.dateFormat = "dd"
            let dayOfMonth = dateFormatter.string(from: now)
            dayString = dayOfMonth
            
        }
        if segue.identifier == "cancelSegue"{
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
