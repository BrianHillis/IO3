//
//  ProjectListTableViewCell.swift
//  IO3
//
//  Created by Christian C on 3/28/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class ProjectListTableViewCell: UITableViewCell {

    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
