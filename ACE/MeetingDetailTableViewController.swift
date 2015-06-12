//
//  MeetingDetailTableViewController.swift
//  ACE
//
//  Created by David Morrison on 11/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class MeetingDetailTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!

    // MARK: - Actions
    @IBAction func makePhoneCall(sender: AnyObject) {
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Sed eu tincidunt dui. Nulla varius, est non convallis bibendum, nisl turpis pellentesque mauris, at euismod dui nisi a arcu. Nulla facilisi. Sed feugiat libero rutrum, bibendum velit eget, malesuada quam."
        addressLabel.text = "Sed eu tincidunt dui.\nSed eu tincidunt dui.\nmsad,.a adskadjlkas"

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
