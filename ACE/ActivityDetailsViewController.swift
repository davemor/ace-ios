//
//  ActivityDetailsViewController.swift
//  ACE
//
//  Created by David Morrison on 26/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class ActivityDetailsViewController: UITableViewController, MKMapViewDelegate {

    // MARK: - Model
    var activity: Activity!
    
    // MARK: - Outlets
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var whenView: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = activity.name
        refreshAddButtonTitle()
        
        // set when
        let start = activity.start.toString()
        let end = activity.end.toString()
        whenView.text = "From \(start) to \(end)"
    
        // set where
        mapView.delegate = self
        setMapLocation(activity.venue.coordinate, delta: 0.025)
        let annotation = ActivityAnnotation(activity: activity)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        addressView.text = activity.venue.fullAddress
    }

    override func viewWillLayoutSubviews() {
        // titleView.preferredMaxLayoutWidth = self.view.bounds.size.width - 40;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    func refreshAddButtonTitle() {
        let title = activity.attending ? "Remove" : "Add"
        addButton.setTitle(title, forState: .Normal)
    }
    
    // MARK: - Actions
    @IBAction func close(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func toggleAttending(sender: UIButton) {
        let realm = Realm()
        realm.write {
            self.activity.attending = !self.activity.attending
        }
        refreshAddButtonTitle()
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        let placemark = MKPlacemark(coordinate: activity.venue.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = activity.name
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    @IBAction func openOnWeb(sender: AnyObject) {
        if let str = activity.url {
            if let url = NSURL(string: str) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                // TODO: Show alert
            }
        }
    }
    
    
    // MARK: - Map View
    let reuseId = "annotationViewReuseId"
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view.canShowCallout = true
            view.image = UIImage(named: "BlueMapPin")!
        }
        
        // configure the annotation
        view.annotation = annotation
        return view
    }    
    
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

class ActivityAnnotation: NSObject, MKAnnotation {
    let myCoordinate: CLLocationCoordinate2D
    let myTitle: String
    
    init(activity: Activity) {
        self.myCoordinate = activity.venue.coordinate
        self.myTitle = activity.name
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
    
    // Title and subtitle for use by selection UI.
    var title: String! {
        return myTitle
    }
}
