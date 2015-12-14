//
//  MeetingsMapViewController.swift
//  ACE
//
//  Created by David Morrison on 05/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MeetingsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterView: UIView!
    
    // hold onto this in the instance the instance is always notified
    var notificationToken: NotificationToken?
    var groups: Results<Group>!
    var meetings: Results<Meeting>!
    
    // model for the filters
    var groupFlags = [String:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        // set up the realm queries
        do {
            groups = try Realm().objects(Group)
            meetings = try Realm().objects(Meeting)
        } catch {
            print("Error querying Realm in MeetingsMapViewController.")
        }
        
        mapView.delegate = self
        self.title = "Meetings"
        
        // move focus the map on Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)
        
        // populate the map
        refresh()
        
        // Set realm notification block
        do {
            try notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
                self.refresh()
            }
        } catch {
            print("Error creating Realm notification token in MeetingsMapViewController.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        // refresh the filter view
        refreshGroupFlags()
        
        // refresh the annotations
        refreshAnnotations()
    }
    
    func refreshGroupFlags() {
        // we want a group flag for each group
        // for each group
        for group in groups {
            if !groupFlags.has(group.name) {
                groupFlags[group.name] = true
            }
        }
        // remove all group in the flags array that are not in the results
        var keysToDelete:[String] = []
        for name in groupFlags.keys {
            if groups.filter("name = '\(name)'").count == 0 {
                keysToDelete.append(name)
            }
        }
        for key in keysToDelete {
            groupFlags.removeValueForKey(key)
        }
    }
    
    func refreshAnnotations() {
        // remove the old ones
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let query = queryFromGroupFlags()
        
        // add the new ones
        let filteredMeetings = meetings.filter(query)
        if filteredMeetings.count > 0 {
            let arrayOfMeetings = filteredMeetings.toArray()
            let groupedMeetings = arrayOfMeetings.groupBy { $0.venue! }
            for (venue, meetings) in groupedMeetings {
                let annotation = MeetingAnnotation(meetings: meetings, venue: Venue(value: venue))
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func queryFromGroupFlags() -> NSPredicate {
        let elements = groupFlags.toArray { (key:String, val:Bool) -> String in
            return val ? "group.name = '\(key)'" : ""
            }.reject {$0.isEmpty}
        let query = elements.joinWithSeparator(" OR ")
        if query.isEmpty {
            return NSPredicate(format: "group == nil")
        }
        return NSPredicate(format: query, "")
    }    
    
    // MARK: - MKMapViewDelegate implementation
    let reuseId = "annotationViewReuseId"
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
        }
        // configure the annotation
        view!.annotation = annotation
        view!.image = (annotation as? MeetingAnnotation)?.pin

        return view
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let meetings = (view.annotation as? MeetingAnnotation)?.meetings {
            if meetings.count == 1 {
                performSegueWithIdentifier("meetingDetailSegue", sender: view)
            } else {
                performSegueWithIdentifier("meetingPickerSegue", sender: view)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func toggleFilter(sender: UIBarButtonItem) {
        UIView.transitionWithView(filterView,
            duration: NSTimeInterval(0.2),
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {},
            completion: nil)
        
        filterView.hidden = !filterView.hidden
    }
    
    @IBAction func caSwitchValueChanged(sender: UISwitch) {
        groupFlags["Cocaine Anonymous"] = sender.on
        refreshAnnotations()
    }

    @IBAction func naSwitchValueChanged(sender: UISwitch) {
        groupFlags["Narcotics Anonymous"] = sender.on
        refreshAnnotations()
    }
    
    @IBAction func smartSwitchValueChanged(sender: UISwitch) {
        groupFlags["SMART Recovery Groups"] = sender.on
        refreshAnnotations()
    }
    
    @IBAction func aaSwitchValueChanged(sender: UISwitch) {
        groupFlags["Alcoholics Anonymous"] = sender.on
        refreshAnnotations()
    }
    
    // MARK: - Navigation

    @IBAction func back(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "meetingDetailSegue" {
            let annotation = sender?.annotation as! MeetingAnnotation // if not then crash!
            let dest = segue.destinationViewController as! MeetingsDetailViewController
            dest.meeting = annotation.meetings.first
            dest.venue = annotation.venue
        } else if segue.identifier == "meetingPickerSegue" {
            let annotation = sender?.annotation as! MeetingAnnotation // if not then crash!
            let dest = segue.destinationViewController as! MeetingPickerViewController
            dest.meetings = annotation.meetings
            dest.venue = annotation.venue
        }
    }


    // helper methods
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

// TODO: This should be more data driven - tight coupling :(
let knownGroupPins = [
    "Cocaine Anonymous" : UIImage(named: "OrangeMapPin")!,
    "Narcotics Anonymous" : UIImage(named: "BlueMapPin")!,
    "SMART Recovery Groups" : UIImage(named: "PinkMapPin")!,
    "Alcoholics Anonymous" : UIImage(named: "PurpleMapPin")!,
    "Many": UIImage(named: "ManyPin")!
]

class MeetingAnnotation : NSObject, MKAnnotation {
    let meetings: [Meeting]
    let venue: Venue
    var pin: UIImage?
    
    // implement the MKAnnotation protocol
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    
    init(meetings: [Meeting], venue: Venue) {
        self.meetings = meetings
        self.venue = venue
        
        self.coordinate = venue.coordinate
        self.pin = knownGroupPins["Many"]!
        
        let grouped = meetings.groupBy {$0.group!}
        if grouped.count == 1 {
            if let group = grouped.keys.first as? Group {
                self.title = group.name
                self.pin = knownGroupPins[group.name]
            }
        } else {
            self.title = venue.name
            self.pin = knownGroupPins["Many"]
        }
    }
}





