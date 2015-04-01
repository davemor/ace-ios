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
    
    let baseUrl = NSURL(string: "https://protected-mountain-5807.herokuapp.com/api/")
    
    var venues:[Venue] = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // zoom to show Edinburgh
        setMapLocation(CLLocationCoordinate2D(latitude: 55.9410655, longitude: -3.2053836), delta: 0.05)
    
        // get the venue locations
        let venuesUrl = NSURL(string: "venues", relativeToURL: baseUrl)
       
        // let venuesData = NSData(contentsOfURL: venuesUrl!, options: nil, error: nil)
        // println(venuesData);
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(venuesUrl!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let venuesArr: NSArray = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSArray
                
                for venueDict in venuesArr {
                    let dict = venueDict as NSDictionary
                    let venue = Venue(dict: dict)
                    
                    // add it to the model
                    self.venues.append(venue)
                    
                    // add it to the map
                    let annotation = MKPointAnnotation()
                    annotation.setCoordinate(venue.location)
                    annotation.title = venue.name
                    self.map.addAnnotation(annotation)
                }
                
            } else {

            }
        })
        downloadTask.resume()
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
