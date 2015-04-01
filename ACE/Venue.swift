//
//  Venue.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import MapKit

struct Venue {
    var name: String
    var address: String
    var city: String
    var postcode: String
    var telephone: String
    var website: String
    var location: CLLocationCoordinate2D
    var services: [Service] = [Service]()
    
    init(name:String, address:String, city:String, postcode:String,
        telephone:String, website:String, latitude: Double, longitude: Double ) {
        self.name = name
        self.address = address
        self.city = city
        self.postcode = postcode
        self.telephone = telephone
        self.website = website
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(dict: NSDictionary) {
        self.name = dict["name"] as String
        self.address = dict["address"] as String
        self.city = dict["city"] as String
        self.postcode = dict["postcode"] as String
        self.telephone = ""
        self.website = ""
        let latitude = dict["latitude"] as Double
        let longitude = dict["longitude"] as Double
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}