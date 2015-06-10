//
//  MeetingsDetailViewController.swift
//  ACE
//
//  Created by David Morrison on 05/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MeetingsDetailViewController: UITableViewController, MKMapViewDelegate {

    var meeting: Meeting!
    var venue: Venue!
    
    // bindings for views
    @IBOutlet weak var nameOfGroupView: UILabel!
    @IBOutlet weak var descriptionOfGroupView: UITextView!
    @IBOutlet weak var timeOfMeetingView: UILabel!
    
    // finding us
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressView: UITextView!
    
    // getting touch
    @IBOutlet weak var contactView: UILabel!
    @IBOutlet weak var contectNumber: UIButton!

    // MARK: - Actions
    
    @IBAction func getDirections(sender: AnyObject) {
        let placemark = MKPlacemark(coordinate: venue.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = meeting.displayName
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    @IBAction func callContact(sender: AnyObject) {
        let phoneNumber = "tel://\(meeting.displayContactPhone.condense())"
        println(phoneNumber)
        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
    }
    
    @IBAction func add(sender: AnyObject) {
        let realm = Realm()
        realm.write {
            let activity = MeetingActivity()
            activity.meeting = self.meeting
            realm.add(activity, update: true)
        }
        var alert = UIAlertController(title: "Added", message: "Meeting added to your calendar", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // bindings for views
        nameOfGroupView.text = meeting.displayName
        descriptionOfGroupView.text = meeting.displayDescription
        timeOfMeetingView.text = meeting.displayTime
        
        // finding us
        setMapLocation(meeting.venue!.coordinate, delta: 0.025)
        let annotation = MeetingAnnotation(meetings: [meeting], venue: meeting.venue!)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        addressView.text = meeting.venue!.fullAddress
        
        // getting touch
        contactView.text = meeting.displayContactName
        contectNumber.setTitle(meeting.displayContactPhone, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - MKMapViewDelegate implementation
    let reuseId = "annotationViewReuseId"
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view.canShowCallout = true
            view.image = (annotation as? MeetingAnnotation)?.pin
        }
        
        // configure the annotation
        view.annotation = annotation
        return view
    }
    
    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
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

    // helper methods
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}
