//
//  ScheduleTableViewCell.swift
//  IO3
//
//  Created by Christian C on 4/4/19.
//  Copyright © 2019 SegFaultZero. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var timeLocationLabel: UILabel!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
//
//    func getIndexPath() -> IndexPath? {
//        guard let superView = self.superview as? UITableView else {
//            print("superview is not a UITableView - getIndexPath")
//            return nil
//        }
//        indexPath = superView.indexPath(for: self)
//        print("Index path: \(String(describing: indexPath))")
//        return indexPath
//    }

}
