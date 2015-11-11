//
//  MeetingActivity.swift
//  ACE
//
//  Created by David Morrison on 26/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class MeetingActivity: Object, Activity {
    dynamic var id = 0
    
    // activities point at meetings
    // when you add a meeting to a calendar
    dynamic var meeting: Meeting?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func includeOnDate(date: NSDate) -> Bool {
        return meeting!.includeOnDate(CVDate(date: date))
    }
    
    // MARK: - Implement the Activity Protocol
    var name: String { return meeting!.displayName }
    var desc: String { return meeting!.displayDescription }
    var start: NSDate { return meeting!.dateTime }
    var end: NSDate {
        let secondsInOneHour = NSTimeInterval(1 * 60 * 60)
        return start.dateByAddingTimeInterval(secondsInOneHour)
    }
    var `repeat`: Repeat { return Repeat(rawValue: meeting!.`repeat`)! }
    var url: String? { return Optional() }
    var venue: Venue? { return meeting!.venue! }
    var attending: Bool {
        get { return true }
        set { /* do nothing */ }
    }
    var color: UIColor  {
        get { return meeting!.group!.color }
    }
}