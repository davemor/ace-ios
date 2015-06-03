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
        
        let meeting = meetingForSectionRow(indexPath.section, row: indexPath.row)

        cell.textLabel?.text = meeting.displayTimeOfDay
        cell.detailTextLabel?.text = meeting.displayName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = orderedMeetings.keys.array[section]
        let day = Day(rawValue: key)
        return day!.description.capitalized
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "meetingDetailSegue" {
            let cell = sender as? UITableViewCell
            let indexPath = tableView.indexPathForCell(cell!)!
            let meeting = meetingForSectionRow(indexPath.section, row: indexPath.row)
            
            let dest = segue.destinationViewController as! MeetingsDetailViewController
            dest.meeting = meeting
            dest.venue = venue
        }
    }
    
    func meetingForSectionRow(section: Int, row: Int) -> Meeting {
        let day = orderedMeetings.keys.array[section]
        let meeting = orderedMeetings[day]![row]
        return meeting
    }
}
