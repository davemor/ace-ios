//
//  PropertyCell.swift
//  ACE
//
//  Created by David Morrison on 21/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

class VenueDetailsCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var title: UITextView!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phoneButton: UIButton!
    
    var venue: Venue?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        map.delegate = self
    }
    
    func setup(venue:Venue) {
        self.venue = venue
        
        // set up the map view
        setMapLocation(venue.location, delta: 0.025)
        let annotation = VenueAnnotation(venue: venue)
        map.addAnnotation(annotation)
        map.selectAnnotation(annotation, animated: true)
    
        // set the information about the venue
        title.text = venue.name
        address.text = "\(venue.address),\n\(venue.city),\n\(venue.postcode)"
        let addressViewSize = address.contentSize
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showDirections(sender: UIButton) {
        let placemark = MKPlacemark(coordinate: venue!.location, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue!.displayName
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    // MARK: - MKMapViewDelegate implementation
    let reuseId = "annotationViewReuseId"
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view.canShowCallout = true
            view.image = (annotation as? VenueAnnotation)?.pin
        }
        
        // configure the annotation
        view.annotation = annotation
        return view
    }
    
    // helper methods
    func setMapLocation(location: CLLocationCoordinate2D, delta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
    }
}
