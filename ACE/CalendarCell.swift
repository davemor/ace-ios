//
//  CalendarCell.swift
//  ARCE
//
//  Created by David Morrison on 13/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
