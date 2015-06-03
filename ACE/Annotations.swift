//
//  Markers.swift
//  ACE
//
//  Created by David Morrison on 21/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Annotation helpers
func getPin(venue:Venue) -> UIImage {
    return mapPins[venue.getStyle()]!!
}

let mapPins = [
    Venue.Style.Venue : UIImage(named: "BlueMapPin"),
    Venue.Style.OneService : UIImage(named: "OrangeMapPin"),
    Venue.Style.OneEvent : UIImage(named: "PurpleMapPin"),
    Venue.Style.ManyServices : UIImage(named: "PinkMapPin"),
    Venue.Style.ManyEvents : UIImage(named: "PinkMapPin"),
]

class VenueAnnotation : NSObject, MKAnnotation {
    let venueId:Int
    let pin:UIImage
    
    // implement the MKAnnotation protocol
    var coordinate:CLLocationCoordinate2D
    var title:String!
    var subtitle:String!
    
    init(venue: Venue) {
        self.venueId = venue.id
        self.coordinate = venue.coordinate
        self.title = venue.displayName
        self.pin = getPin(venue)
    }
}