//
//  Venue.swift
//  ace-model
//
//  Created by David Morrison on 17/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Venue: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var address = ""
    dynamic var city = ""
    dynamic var postcode = ""
    dynamic var email = ""
    dynamic var telephone = ""
    dynamic var website = ""
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    static override func primaryKey() -> String? {
        return "id"
    }
    
    var meetings: [Meeting] {
        return linkingObjects(Meeting.self, forProperty: "venue")
    }
    
    var services: [Service] {
        return linkingObjects(Service.self, forProperty: "service")
    }
    
    // some helper functions for working out how best to display stuff
    enum Style {
        case Venue
        case OneService
        case OneEvent
        case ManyServices
        case ManyEvents
    }
    
    func getStyle() -> Style {
        switch (self.services.count, self.meetings.count) {
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
        case .OneService: return self.services.first!.name
        case .OneEvent: return self.meetings.first!.displayName
        default: return name
        }
    }
    
    var fullAddress: String {
        return "\(self.address),\n\(self.city),\n\(self.postcode)"
    }
    
    var coordinate:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}