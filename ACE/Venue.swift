//
//  Venue.swift
//  ACE
//
//  Created by David Morrison on 01/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import MapKit

struct Venue {
    var id: Int
    var name: String
    var address: String
    var city: String
    var postcode: String
    var telephone: String
    var website: String
    var location: CLLocationCoordinate2D
    var services: [Service] = [Service]()
    var events: [Event] = [Event]()
    
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
    
    // some helper functions for working out how best to display stuff
    enum Style {
        case Venue
        case OneService
        case OneEvent
        case ManyServices
        case ManyEvents
    }
    
    func getStyle() -> Style {
        switch (self.services.count, self.events.count) {
        case (0, 0): return .Venue
        case (0, 1): return .OneEvent
        case (0, _): return .ManyEvents
        case (1, 0): return .OneService
        case (_, 0): return .ManyServices
        case (_, _): return .Venue
        }
    }
    
    var displayName: String {
        switch getStyle() {
        case .OneService: return services[0].displayName
        case .OneEvent: return events[0].displayName
        default: return name
        }
    }
}