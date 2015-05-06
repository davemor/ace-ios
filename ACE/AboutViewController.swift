//
//  AboutViewController.swift
//  ACE
//
//  Created by David Morrison on 06/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {

    
    @IBOutlet weak var recoveryStartDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var daysSwitch: UISwitch!
    @IBOutlet weak var badgesSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // load the values of the switches
        let defaults = NSUserDefaults.standardUserDefaults()
       // let startDate =
        // recoveryStartDateButton.setTitle(<#title: String?#>, forState: .Normal)
        daysSwitch.on = defaults.boolForKey("show_days_in_recovery")
        badgesSwitch.on = defaults.boolForKey("show_milestone_badges")
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
    
    @IBAction func toggleEditDate(sender: UIButton) {
        isEditingDate = !isEditingDate
        
        // animate the cell open/close
        
        /*
        UIView.animateWithDuration(2.0, animations: {
            let pathOfPickerCell = NSIndexPath(forRow: 1, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([pathOfPickerCell], withRowAnimation: UITableViewRowAnimation.Fade)
            
            //self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: 3)), withRowAnimation: .Automatic)
            
            self.tableView.reloadData()
            
            let alpha = self.isEditingDate ? CGFloat(1.0) : CGFloat(0.0)
            self.datePicker.alpha = alpha
            
            let targetColor = self.isEditingDate ? UIColor.redColor() : UIColor.blackColor()
            self.recoveryStartDateButton.setTitleColor(targetColor, forState: .Normal)
        })
        */
        
        UIView.animateWithDuration(2.0, animations: {
            let targetColor = self.isEditingDate ? UIColor.redColor() : UIColor.blackColor()
            self.recoveryStartDateButton.setTitleColor(targetColor, forState: .Normal)
        })
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()

    }
    
    // MARK: - Date picker
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        setLabelToDate(sender.date)
    }
    
    func setLabelToDate(date: NSDate) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateStr = dateFormatter.stringFromDate(date)
        recoveryStartDateButton.setTitle(dateStr, forState: .Normal)
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    */


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
