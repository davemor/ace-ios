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

    func includeOnDate(date: NSDate) -> Bool {
        // check if the day falls between the start and end days
        let start = dateWithTime(startDate, hour: 0, minute: 0, second: 0)
        let end = dateWithTime(endDate, hour: 23, minute: 59, second: 59)
        return dateIsBetween(date, start, end)
    }
    
    // MARK: - Implement the Activity Protocol
    var name: String { return summary }
    var desc: String { return aDescription }
    var start: NSDate { return startDate }
    var end: NSDate { return endDate }
    var repeat: Repeat { return .none }
    var url: String? { return aURL }
    var venue: Venue { return aVenue! }
    var attending: Bool {
        get { return isAttending }
        set { isAttending = newValue }
    }
    
    private func dateWithTime(date:NSDate, hour:Int, minute:Int, second:Int) -> NSDate {

        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        
        let components = NSDateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = hour
        components.minute = minute
        components.second = second
        let rtnDate = calendar.dateFromComponents(components)
        
        return rtnDate!
    }
}