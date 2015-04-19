//
//  Venue.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import MapKit

struct Venue : Printable {
    var id: Int
    var name: String
    var address: String
    var city: String
    var postcode: String
    var telephone: String
    var website: String
    var location: CLLocationCoordinate2D
    var services: [Service] = [Service]()
    
    init(id:Int, name:String, address:String, city:String, postcode:String,
        telephone:String, website:String, latitude: Double, longitude: Double ) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.postcode = postcode
        self.telephone = telephone
        self.website = website
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(dict: NSDictionary) {
        self.id         = read("id", dict, 0)
        self.name       = read("name", dict, "")
        self.address    = read("address", dict, "")
        self.city       = read("city", dict, "")
        self.postcode   = read("postcode", dict, "")
        self.telephone  = read("telephone", dict, "")
        self.website    = read("website", dict, "")
        let latitude    = read("latitude", dict, 0.0)
        let longitude   = read("longitude", dict, 0.0)
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // access to the collection of all venues
    static var all:[Int:Venue]  = [Int:Venue]()
}