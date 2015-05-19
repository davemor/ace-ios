//
//  MeetingsListViewController.swift
//  ACE
//
//  Created by David Morrison on 07/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit

class MeetingsListViewController: UITableViewController {

    /*
    // array of event lists ordered by day then ordered by time
    var orderedMeetings:[Event.Day:[Event]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let events = Event.all
        
        // group the meetings by day then order lists by time
        orderedMeetings = events.groupBy({ (id:Int, event:Event) -> Event.Day in
            event.day
        })
            /*
            .mapValues { (_, meetings:[Event]) -> [Event] in
            meetings.sortUsing({ (event:Event) in event.dateTime })
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func back(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // one section for each day, event when there are not meetings on that day
        // that allows the section indexes to map to the day keys in the orderedMeetings
        // list.
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = Event.Day(rawValue: section)!
        if let count = orderedMeetings[day]?.count {
            return count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("meetingsListReuseIdentifier", forIndexPath: indexPath) as! MeetingCell

        let day = Event.Day(rawValue: indexPath.section)!
        if let meetings = orderedMeetings[day] {
            let meeting = meetings[indexPath.row]
            cell.title.text = meeting.displayTimeOfDay
            cell.subtitle.text = meeting.displayName
            cell.meeting = meeting // TODO: bit of a hack perhaps?
        }
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = Event.Day(rawValue: section)
        return day?.description
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "meetingDetailSegue" {
            let cell = sender as? MeetingCell
            let dest = segue.destinationViewController as? MeetingsDetailViewController
            dest?.meeting = cell?.meeting
        }
    }
    */
}
