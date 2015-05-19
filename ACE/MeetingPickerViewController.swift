//
//  MeetingPickerViewController.swift
//  ACE
//
//  Created by David Morrison on 19/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class MeetingPickerViewController: UITableViewController {

    var meetings: [Meeting]!
    var venue: Venue!
    
    var orderedMeetings: [Int:[Meeting]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // order the meetings
        orderedMeetings = meetings.groupBy { (meeting:Meeting) -> Int in
            meeting.day
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orderedMeetings.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = orderedMeetings.keys.array[section]
        return orderedMeetings[day]!.count
    }

    let reuseId = "pickerCellReuseId"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! UITableViewCell
        
        let day = orderedMeetings.keys.array[indexPath.section]
        let meeting = orderedMeetings[day]![indexPath.row]
        cell.textLabel?.text = meeting.displayName
    
        return cell
    }

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
