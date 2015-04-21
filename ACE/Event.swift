//
//  Event.swift
//  ACE
//
//  Created by David Morrison on 19/04/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation

struct Event {
    let id:Int
    let name:String
    let description:String
    let contactName:String
    let contactPhone:String
    let dateTime:NSDate
    let repeat:Repeat
    let day:Day
    let venueId:Int
    let groupId:Int
    
    enum Repeat {
        case none
        case weekly
        case monthly
    }
    enum Day {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    init(dict: NSDictionary) {
        self.id = read("id", dict, 0)
        self.name = read("name", dict, "")
        self.description = read("description", dict, "")
        self.contactName = read("contact_name", dict, "")
        self.contactPhone = read("contact_phone", dict, "")
        self.dateTime = readDate("date_time", dict)
        self.venueId = read("venue_id", dict, 0)
        self.groupId = read("group_id", dict, 0)
        
        // repeat
        switch read("repeat", dict, "") {
            case "none": self.repeat = .none
            case "weekly": self.repeat = .weekly
            case "monthly": self.repeat = .monthly
            default: self.repeat = .none
        }
        
        // day
        switch read("repeat", dict, "") {
            case "monday": self.day = .monday
            case "tuesday": self.day = .tuesday
            case "wednesday": self.day = .wednesday
            case "thursday": self.day = .thursday
            case "friday": self.day = .friday
            case "saturday": self.day = .saturday
            case "sunday": self.day = .sunday
            default: self.day = .monday
        }
        
        // add to the venue and group
        Venue.all[self.venueId]?.events.append(self)
    }
    
    static var all:[Int:Event]  = [Int:Event]()
    
    var displayName: String {
        if name.isEmpty {
            if let group = Group.all[groupId] {
                return group.name
            } else {
                return "unknown"
            }
        } else {
            return name
        }
    }
}