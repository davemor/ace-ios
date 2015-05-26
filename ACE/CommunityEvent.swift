//
//  CommunityEvent.swift
//  ACE
//
//  Created by David Morrison on 26/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class CommunityActivity: Object, Activity {
    dynamic var slug = 0
    dynamic var summary = ""
    dynamic var aDescription = ""
    dynamic var startDate = NSDate()
    dynamic var endDate = NSDate()
    dynamic var aURL = ""
    dynamic var aVenue: Venue? // this should always be present
    
    dynamic var isAttending = false
    
    override static func primaryKey() -> String? {
        return "slug"
    }

    // MARK: - Implement the Activity Protocol
    var name: String { return summary }
    var desc: String { return aDescription }
    var start: NSDate { return startDate }
    var end: NSDate { return endDate }
    var repeat: Repeat { return .none }
    var url: String? { return aURL }
    var venue: Venue { return aVenue! }
    var attending: Bool { return isAttending }
}