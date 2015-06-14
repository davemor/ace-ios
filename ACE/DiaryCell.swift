//
//  DiaryCell.swift
//  ARCE
//
//  Created by David Morrison on 14/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
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
