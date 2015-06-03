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
        UIApplication.sharedApplication().openURL(NSURL(string:"sms:\(phone)")!)
    }
    
    @IBAction func phone(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"tel://\(phone)")!)
    }
}
