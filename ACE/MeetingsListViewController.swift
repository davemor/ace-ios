//
//  MeetingsListViewController.swift
//  ACE
//
//  Created by David Morrison on 07/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift

class MeetingsListViewController: UITableViewController {

    // array of event lists ordered by day then ordered by time
    var orderedMeetings:[Day:[Meeting]]!
    
    var notificationToken: NotificationToken?
    let groups = Realm().objects(Group)
    let meetings = Realm().objects(Meeting)
    
    // keep track of which sections are expanded
    var sectionOpen = [
        0 : false,
        1 : false,
        2 : false,
        3 : false,
        4 : false,
        5 : false,
        6 : false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.refresh()
        }
        
        self.refresh()
    }
    
    func refresh() {
        orderedMeetings = Array(meetings.generate()).groupBy { Day(rawValue: $0.day)! }.mapValues { (day:Day, meetings:Array<Meeting>) -> Array<Meeting> in
            meetings.sortUsing { $0.dateTime }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func back(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func sectionExpand(sender: UIButton) {
        sectionOpen[sender.tag] = !sectionOpen[sender.tag]!
         self.tableView.reloadSections(NSIndexSet(index: sender.tag), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionOpen[section]! {
            let day = Day(rawValue: section)!
            if let count = orderedMeetings[day]?.count {
                return count
            }
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("meetingsListReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        let day = Day(rawValue: indexPath.section)!
        if let meetings = orderedMeetings[day] {
            let meeting = meetings[indexPath.row]
            cell.textLabel?.text = meeting.displayTimeOfDay
            cell.detailTextLabel?.text = meeting.displayName
        }
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellId = "sectionHeader"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! MeetingsListHeader
        let day = Day(rawValue: section)!
        cell.titleLabel.text = day.description.capitalized
        cell.expandButton.tag = section
        cell.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        
        var view = UIView(frame: cell.frame)
        
        view.addSubview(cell)
        return view
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "meetingDetailSegue" {
            let dest = segue.destinationViewController as? MeetingsDetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let day = Day(rawValue: indexPath.section)!
            let meeting = orderedMeetings[day]![indexPath.row]
            dest?.meeting = meeting
            dest?.venue = meeting.venue
        }
    }
}
