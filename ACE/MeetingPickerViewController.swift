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
    
    var orderedMeetings: [(Int,[Meeting])]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // order the meetings
        orderedMeetings = meetings
        .groupBy { $0.day }
        .toArray { (day:$0, meetings:$1) }
        .sortUsing { (day:Int, meetings:Array<Meeting>) -> Int in
            return day
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
        return orderedMeetings[section].1.count
    }

    let reuseId = "meetingsListReuseIdentifier"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! MeetingListCell
        let meeting = meetingForSectionRow(indexPath.section, row: indexPath.row)
        cell.fellowship.text = meeting.displayName
        cell.time.text = meeting.displayTimeOfDay
        cell.backgroundColor = meeting.group!.color
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = orderedMeetings[section].0
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
        let meeting = orderedMeetings[section].1[row]
        return meeting
    }
}
