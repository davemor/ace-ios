//
//  ContactCell.swift
//  ACE
//
//  Created by David Morrison on 03/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    var phone = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions
    @IBAction func text(sender: UIButton) {
        // [[UIApplication sharedApplication] openURL: @"sms:98765432"];
        if let url = NSURL(string:"sms:\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func phone(sender: UIButton) {
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
