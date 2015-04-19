//
//  ServicesMapViewController.swift
//  ACE
//
//  Created by David Morrison on 19/03/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class ServicesMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    // let baseUrl = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")
    let baseUrl = NSURL(string: "http://localhost:3000/api/")
    
    var venues:[Venue] = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // zoom to show Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)

        // add all the venues to the map
        for (id,venue) in Venue.all {
            let annotation = MKPointAnnotation()
            annotation.coordinate = venue.location
            annotation.title = venue.name
            self.map.addAnnotation(annotation)
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
