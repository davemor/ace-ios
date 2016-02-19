//
//  AboutViewController.swift
//  ACE
//
//  Created by David Morrison on 06/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import Mixpanel

class AboutViewController: UITableViewController {
    
    @IBOutlet weak var recoveryStartDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var daysSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // log with analytics
        Mixpanel.sharedInstance().track("About Section Opened")
        
        // load the values of the switches
        let defaults = NSUserDefaults.standardUserDefaults()
        let date = loadDateFromUserDefaults(defaults)
        datePicker.date = date
        setLabelToDate(date)
        daysSwitch.on = defaults.boolForKey("show_days_in_recovery")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func close(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func toggleShowDaysInRecovery(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "show_days_in_recovery")
    }

    @IBAction func toggleShowMilestoneBadges(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "show_milestone_badges")
    }
    
    // MARK: Expanding date picker stuff
    var isEditingDate = false
    
    @IBAction func dateCellTapped(sender: AnyObject) {
        toggleEditDate()
    }
    func toggleEditDate() {
        isEditingDate = !isEditingDate
        UIView.animateWithDuration(1.0, animations: {
            let targetColor = self.isEditingDate ? UIColor.redColor() : UIColor.blackColor()
            self.recoveryStartDateButton.setTitleColor(targetColor, forState: .Normal)
        })
        //self.tableView.beginUpdates()
        self.tableView.reloadData()
        //self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 3)) , withRowAnimation: UITableViewRowAnimation.None)
        //self.tableView.endUpdates()
    }
    
    // MARK: - Date picker
    // TODO: Perhaps move the NSDateFormatter out somewhere and reuse it.
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        if isInPast(sender.date) {
            setLabelToDate(sender.date)
            saveDateToUserDefaults(sender.date)
        } else {
            // show an alert
            let alert = UIAlertController(title: "Alert", message: "Your recovery should not start in the future.  Let's do it now!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                // reset the picker
                let defaults = NSUserDefaults.standardUserDefaults()
                let oldDate = self.loadDateFromUserDefaults(defaults)
                self.datePicker.setDate(oldDate, animated: true)
            })
        }
    }
    func isInPast(date:NSDate) -> Bool {
        let difference = daysBetweenDates(date, endDate: NSDate())
        // print("\(difference)")
        return difference >= 0
    }
    func setLabelToDate(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        recoveryStartDateButton.setTitle(dateStr, forState: .Normal)
    }
    func loadDateFromUserDefaults(defaults: NSUserDefaults) -> NSDate {
        if let dateStr = defaults.stringForKey("recovery_start_date") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            if let rtn = dateFormatter.dateFromString(dateStr) {
                return rtn
            } else {
                return NSDate() // now
            }
        } else {
            return NSDate() // now
        }
    }
    func saveDateToUserDefaults(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dateStr, forKey: "recovery_start_date")
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            if isEditingDate {
                return 162.0
            } else {
                return 0.0
            }
        } else {
            return 44.0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
