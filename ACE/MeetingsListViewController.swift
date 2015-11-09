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
    var groups: Results<Group>!
    var meetings: Results<Meeting>!
    
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
        self.title = "Meetings"
        
        do {
            groups = try Realm().objects(Group)
            meetings = try Realm().objects(Meeting)
        } catch {
            print("Error loading from Realm in MeetingsListViewController.")
        }
        
        do {
            notificationToken = try Realm().addNotificationBlock { [unowned self] note, realm in
                self.refresh()
            }
        } catch {
            print("Error creating notification token in MeetingsListViewController.")
        }
        
        self.refresh()
    }
    
    func refresh() {
        // TODO: This is not good - revisit
        let meetingsArr = meetings.toArray()
        let groupedMeetings = meetingsArr.groupBy { Day(rawValue: $0.day)! }
        var newMeetings = [Day:[Meeting]]()
        for g in groupedMeetings {
            newMeetings[g.0] = g.1.sort { $0.dateTime.compare($1.dateTime) == NSComparisonResult.OrderedAscending }
        }
        orderedMeetings = newMeetings
        
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

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
        let cell = tableView.dequeueReusableCellWithIdentifier("meetingsListReuseIdentifier", forIndexPath: indexPath) as! MeetingListCell

        let day = Day(rawValue: indexPath.section)!
        if let meetings = orderedMeetings[day] {
            let meeting = meetings[indexPath.row]
            cell.fellowship.text = meeting.displayName
            cell.time.text = meeting.displayTimeOfDay
            cell.backgroundColor = meeting.group!.color
        }
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellId = "sectionHeader"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! MeetingsListHeader
        let day = Day(rawValue: section)!
        
        cell.titleLabel.text = day.description.capitalizedString
        cell.expandButton.tag = section
        let title = sectionOpen[section]! ? "Close" : "Open"
        cell.expandButton.setTitle(title, forState: .Normal)
        cell.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        let view = UIView(frame: cell.frame)
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
