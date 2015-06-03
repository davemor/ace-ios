//
//  ServicesMapViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class ServicesMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        
        // zoom to show Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)

        // add all the venues to the map
        //for (id,event) in Event.all {
        //    let annotation = EventAnnotation(event: event)
        //    self.map.addAnnotation(annotation)
        //}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // helper methods
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate implementation
    let reuseId = "annotationViewReuseId"
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
            // view.image = (annotation as? EventAnnotation)?.pin
        }
        // configure the annotation
        view.annotation = annotation
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.performSegueWithIdentifier("venueDetailsSegue", sender: view.annotation)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let annotation = sender as? VenueAnnotation
        if let dest = segue.destinationViewController as? VenueDetailViewController {
           // dest.venue = Venue.all[annotation!.venueId]!
        }
    }
}
