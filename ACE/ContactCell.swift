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
    
    var parent: EmergencyContactViewController!
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
        parent.sendText(phone)
    }
    
    @IBAction func phone(sender: UIButton) {
        let str = "tel://\(phone.condense())"
        if let url = NSURL(string: str) {
            UIApplication.sharedApplication().openURL(url)
        } else {
            showInvalidNumberAlert()
        }
    }
    
    func showInvalidNumberAlert() {
        // TODO: Add this.
    }
}
