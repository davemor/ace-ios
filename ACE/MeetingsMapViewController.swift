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
import Mixpanel

class MeetingsMapViewController: UIViewController, MKMapViewDelegate, FilterViewListener {

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
        
        filterViewController = FilterViewController()
        filterViewController.addListener(self)
        
        self.navigationController!.navigationBar.translucent = false;

        // log with analytics
        Mixpanel.sharedInstance().track("Meetings Map Opened")
        
        // set up the realm queries
        do {
            let realm = try Realm()
            groups = realm.objects(Group)
            meetings = realm.objects(Meeting)
        } catch {
            print("Error querying Realm in MeetingsMapViewController.")
        }
        
        mapView.delegate = self
        self.title = "Meetings"
        
        // move focus the map on Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)
        
        // populate the map
        refreshAnnotations(filterViewController.activeCategories)
        
        // Set realm notification block
        do {
            try notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
                self.refreshAnnotations(self.filterViewController.activeCategories)
            }
        } catch {
            print("Error creating Realm notification token in MeetingsMapViewController.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshAnnotations(selected: Set<String>) {
        // remove the old ones
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let query = queryFromGroupFlags(selected)
        
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
    
    func queryFromGroupFlags(selected: Set<String>) -> NSPredicate {
        let query = selected.map { "group.name = '\($0)'" }.joinWithSeparator(" OR ")
        if query.isEmpty {
            return NSPredicate(format: "group == nil")
        }
        return NSPredicate(format: query, "")
    }
    
    // MARK: - FilterViewListener
    func filterSelectionHasChanged(selected: Set<String>) {
        refreshAnnotations(selected)
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
    
    // MARK: - Filtering
    
    var filterViewController:FilterViewController!
    var isShowingFilter = false
    
    @IBAction func toggleFilter(sender: UIBarButtonItem) {
        if isShowingFilter {
            hideContentController(filterViewController)
            isShowingFilter = false
        } else {
            displayContentController(filterViewController)
            isShowingFilter = true
        }
    }
    
    func displayContentController(content: UIViewController) {
        self.addChildViewController(content)
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
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
        
        let grouped = meetings.groupBy { (meeting: Meeting) -> String in
            if let group = meeting.group {
                return group.name
            } else {
                return ""
            }
        }
        if grouped.count == 1 {
            self.title = self.meetings[0].name
            self.pin = knownGroupPins[grouped.keys.first!]
        } else {
            self.title = venue.name
            self.pin = knownGroupPins["Many"]
        }
    }
}





