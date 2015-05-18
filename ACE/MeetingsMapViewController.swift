//
//  MeetingsMapViewController.swift
//  ACE
//
//  Created by David Morrison on 05/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class MeetingsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        // move focus the map on Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)
        
        // add all the events to the list
        let groupedMeetings = Event.all.groupBy { (id:Int, event:Event) -> Int in
            return event.venue.id
        }
        for (id, events) in groupedMeetings {
            let annotation = MeetingAnnotation(events: events)
            self.mapView.addAnnotation(annotation)
        }
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
            view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
            view.image = (annotation as? MeetingAnnotation)?.pin
        }
        // configure the annotation
        view.annotation = annotation
        return view
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("meetingDetailSegue", sender: view)
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
        
    }

    @IBAction func naSwitchValueChanged(sender: UISwitch) {
    }
    
    @IBAction func smartSwitchValueChanged(sender: UISwitch) {
    }
    
    @IBAction func aaSwitchValueChanged(sender: UISwitch) {
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
            dest.meeting = Event.all[annotation.eventId]
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
let knownGroupsPins = [
    "Cocaine Anonymous" : UIImage(named: "OrangeMapPin"),
    "Narcotics Anonymous" : UIImage(named: "BlueMapPin"),
    "SMART Recovery Groups" : UIImage(named: "PinkMapPin"),
    "Alcoholics Anonymous" : UIImage(named: "PurpleMapPin")
]

class MeetingAnnotation : NSObject, MKAnnotation {
    let eventId:Int
    let pin:UIImage
    
    // implement the MKAnnotation protocol
    var coordinate:CLLocationCoordinate2D
    var title:String!
    var subtitle:String!
    
    init(events: [Event]) {
        let event = events[0]
            self.eventId = event.id
            self.coordinate = Venue.find(event.venueId)!.location
            self.title = event.displayName
            
            // select a pin
            if events.count == 1 {
                if let group = Group.find(event.groupId) {
                    if let p = knownGroupsPins[group.name]! {
                        self.pin = p
                    } else {
                        print("Missing pin on \(group.name)")
                        self.pin = UIImage()
                    }
                } else {
                    // no group
                    self.pin = UIImage()
                }
            } else {
                self.pin = UIImage(named: "LargeBlueMapPin")!
            }
        
    }
}