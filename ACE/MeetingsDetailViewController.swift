//
//  MeetingDetailTableViewController.swift
//  ACE
//
//  Created by David Morrison on 11/06/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MeetingsDetailViewController: UITableViewController {

    var meeting: Meeting!
    var venue: Venue!
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addBarButton: UIBarButtonItem!


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = meeting.displayName
        dateTimeLabel.text = meeting.displayTime
        addressLabel.text = meeting.venue?.fullAddress
        descriptionLabel.text = meeting.displayDescription
        contactLabel.text = meeting.displayContactName
        phoneButton.setTitle(meeting.displayContactPhone, forState: .Normal)
        
        // configure the tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        // setup the model
        if let _ = findActivityForMeeting() {
            addBarButton.title = "Remove"
        } else {
            addBarButton.title = "Add"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    @IBAction func toggleAttending(sender: UIBarButtonItem) {
        do {
            let realm = try Realm()
            if let activity = findActivityForMeeting() {
                try realm.write { realm.delete(activity) }
                addBarButton.title = "Add"
                let alert = UIAlertController(title: "Removed", message: "The meeting has been removed from your calendar.", preferredStyle: .Alert)
                alert.addAction( UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                try realm.write {
                    let activity = MeetingActivity()
                    activity.meeting = self.meeting
                    // print(self.meeting)
                    realm.add(activity, update: true)
                }
                addBarButton.title = "Remove"
                let alert = UIAlertController(title: "Added", message: "The meeting has been added to your calendar.", preferredStyle: .Alert)
                alert.addAction( UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        } catch {
            print("Error toggleAttending with Realm")
        }
    }

    @IBAction func showOnMap(sender: AnyObject) {
        let placemark = MKPlacemark(coordinate: venue.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = meeting.displayName
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    @IBAction func phone(sender: AnyObject) {
        let phoneNumber = "tel://\(meeting.displayContactPhone.condense())"
        // print(phoneNumber)
        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
    }
    
    // MARK: Helpers
    func findActivityForMeeting() -> MeetingActivity? {
        do {
            let query = "meeting.id = \(meeting.id)"
            let results = try Realm().objects(MeetingActivity).filter(query)
            return results.first
        } catch {
            return nil
        }
    }
}
