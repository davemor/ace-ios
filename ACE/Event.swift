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
        id = read("id", dict, 0)
        name = read("name", dict, "missing")
        description = read("description", dict, "missing")
        contactName = read("contact_name", dict, "missing")
        contactPhone = read("contact_phone", dict, "missing")
        dateTime = readDate("date_time", dict)
        venueId = read("venue_id", dict, 0)
        groupId = read("group_id", dict, 0)
        
        // repeat
        switch read("repeat", dict, "missing") {
            case "none": repeat = .none
            case "weekly": repeat = .weekly
            case "monthly": repeat = .monthly
            default: repeat = .none
        }
        
        // day
        switch read("repeat", dict, "missing") {
            case "monday": day = .monday
            case "tuesday": day = .tuesday
            case "wednesday": day = .wednesday
            case "thursday": day = .thursday
            case "friday": day = .friday
            case "saturday": day = .saturday
            case "sunday": day = .sunday
            default: day = .monday
        }
    }
    
    static var all:[Int:Event]  = [Int:Event]()
}