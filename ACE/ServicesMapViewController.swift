//
//  ServicesMapViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import Mixpanel

class ServicesMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var notificationToken: NotificationToken?
    var services: Results<Service>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // log with analytics
        Mixpanel.sharedInstance().track("Services Map Opened")
        
        do {
            services = try Realm().objects(Service)
        } catch {
            print("Error querying Realm from ServicesMapViewController.")
        }
        
        map.delegate = self
        
        // zoom to show Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)

        // Set up the view and the notificaiton block
        refresh()
        
        do {
            notificationToken = try Realm().addNotificationBlock { [unowned self] note, realm in
                self.refresh()
            }
        } catch {
            print("Error setting up Notification token in ServicesMapViewController.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        for service in services {
            if let venue = service.venue {
                let annotation = VenueAnnotation(venue: venue)
                map.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    // MARK: - helper methods
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate implementation
    let reuseId = "annotationViewReuseId"
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIView
            view!.image = UIImage(named: "BlueMapPin")
        }
        // configure the annotation
        view!.annotation = annotation
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("venueDetailsSegue", sender: view.annotation)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let annotation = sender as? VenueAnnotation
        if let dest = segue.destinationViewController as? VenueDetailViewController {
            dest.venue = annotation?.venue
        }
    }
}
