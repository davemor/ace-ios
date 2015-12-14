//
//  AppointmentActivityDetailsViewController.swift
//  ARC
//
//  Created by David Morrison on 14/12/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AppointmentActivityDetailsViewController : UITableViewController {
    var appointment: AppointmentActivity!
    
    // outlets
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var addressCell: UITableViewCell!
    @IBOutlet weak var cityCell: UITableViewCell!
    @IBOutlet weak var postcode: UITableViewCell!
    @IBOutlet weak var notesCell: UITableViewCell!
    
    // lifecycle
    override func viewDidLoad() {
        titleCell.textLabel?.text = appointment.title
        
        // set up the date and time field
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        let datetimeStr = formatter.stringFromDate(appointment.dateTime)
        dateCell.textLabel?.text = datetimeStr
    
        addressCell.textLabel?.text = appointment.address
        cityCell.textLabel?.text = appointment.city
        postcode.textLabel?.text = appointment.postcode
        notesCell.textLabel?.text = appointment.notes
    }
    
    // actions
    @IBAction func remove(sender: AnyObject) {
        
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(appointment)
            try realm.commitWrite()
            
            self.navigationController?.popViewControllerAnimated(true)
        } catch {
            print("Error toggling attending in EAppointmentActivityDetailsViewController.")
        }
        
    }
}