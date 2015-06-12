//
//  MeetingListCell.swift
//  ACE
//
//  Created by David Morrison on 11/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class MeetingListCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var fellowship: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
