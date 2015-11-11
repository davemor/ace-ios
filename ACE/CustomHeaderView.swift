//
//  CustomHeaderView.swift
//  ARC
//
//  Created by Andrew Sage on 11/11/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    @IBOutlet var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.preferredMaxLayoutWidth = label.bounds.width
    }

}
