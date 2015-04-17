//
//  Venue.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import MapKit

struct Venue: Printable {
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
        self.id         = getInt("id", dict, 0)
        self.name       = getString("name", dict, "")
        self.address    = getString("address", dict, "")
        self.city       = getString("city", dict, "")
        self.postcode   = getString("postcode", dict, "")
        self.telephone  = getString("telephone", dict, "")
        self.website    = getString("website", dict, "")
        let latitude    = getDouble("latitude", dict, 0.0)
        let longitude   = getDouble("longitude", dict, 0.0)
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var description: String {
        return " { \(id), \(name)}"
    }
}

// TODO: Move these over to generic methods
func getString(key: String, dict:NSDictionary, alt:String) -> String {
    if let obj = dict.objectForKey(key) as? String {
        return obj
    } else {
        return alt
    }
}

func getDouble(key: String, dict:NSDictionary, alt:Double) -> Double {
    if let obj = dict.objectForKey(key) as? Double {
        return obj
    } else {
        return alt
    }
}

func getInt(key: String, dict:NSDictionary, alt:Int) -> Int {
    if let obj = dict.objectForKey(key) as? Int {
        return obj
    } else {
        return alt
    }
}