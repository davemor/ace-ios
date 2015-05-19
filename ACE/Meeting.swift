//
//  Meeting.swift
//  ace-model
//
//  Created by David Morrison on 17/05/2015.
//  Copyright (c) 2015 David Morrison. All rights reserved.
//

import Foundation
import RealmSwift

class Meeting: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var contactName = ""
    dynamic var contactPhone = ""
    dynamic var dateTime = NSDate()
    dynamic var repeat = 0
    dynamic var day = 0
    dynamic var venue: Venue?
    dynamic var group: Group?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // helpers
    
    enum Repeat: Int, Printable {
        case none
        case weekly
        case monthly
        
        var description : String {
            switch self {
            case .none: return "none"
            case .weekly: return "weekly"
            case .monthly: return "monthly"
            }
        }
        
        static func fromString(str: String) -> Repeat {
            switch str {
            case "none": return .none
            case "weekly": return .weekly
            case "monthly": return .monthly
            default: return .none
            }
        }
        
        static func strToRaw(str: String) -> Int {
            return fromString(str).rawValue
        }
    }
    enum Day: Int, Printable {
        case monday = 0
        case tuesday = 1
        case wednesday = 2
        case thursday = 3
        case friday = 4
        case saturday = 5
        case sunday = 6
        
        var description : String {
            switch self {
            case .monday: return "monday"
            case .tuesday: return "tuesday"
            case .wednesday: return "wednesday"
            case .thursday: return "thursday"
            case .friday: return "friday"
            case .saturday: return "saturday"
            case .sunday: return "sunday"
            }
        }
        
        static func fromString(str: String) -> Day {
            switch str {
            case "monday": return .monday
            case "tuesday": return .tuesday
            case "wednesday": return .wednesday
            case "thursday": return .thursday
            case "friday": return .friday
            case "saturday": return .saturday
            case "sunday": return .sunday
            default: return .monday
            }
        }
        
        static func strToRaw(str: String) -> Int {
            return fromString(str).rawValue
        }
    }
    
    // computed values for public interface
    
    var displayName: String {
        var rtn = "unknown"
        if self.name.isEmpty {
            if let g = self.group {
                rtn = g.name
            }
        }
        return rtn
    }
    
    var displayDescription: String {
        var rtn = "unknown"
        if self.desc.isEmpty {
            if let g = self.group {
                rtn = g.desc
            }
        }
        return rtn
    }
    
    var displayTime: String {
        var format = NSDateFormatter()
        // format.timeZone = NSTimeZone.localTimeZone()
        
        let rtn: String
        switch self.repeated {
        case .none:
            format.dateFormat = "MMM dd, yyyy HH:mm a"
            rtn = format.stringFromDate(self.dateTime)
        case .weekly:
            format.dateFormat = "HH:mm a"
            rtn = "Every \(self.dayOfWeek.description.capitalizedString) at \(format.stringFromDate(self.dateTime))"
        case .monthly:
            format.dateFormat = "dd, HH:mm a"
            rtn = "Every month on the \(format.stringFromDate(self.dateTime))"
        }
        return rtn
    }
    
    var displayTimeOfDay: String {
        var format = NSDateFormatter()
        format.dateFormat = "HH:mm a"
        return format.stringFromDate(self.dateTime)
    }
    
    var displayContactName: String {
        if contactName.isEmpty {
            if let g = self.group {
                return g.contactName
            } else {
                return "unknown"
            }
        } else {
            return contactName
        }
    }
    var displayContactPhone: String {
        if contactPhone.isEmpty {
            if let g = self.group {
                return g.telephone
            } else {
                return "unknown"
            }
        } else {
            return contactPhone
        }
    }
    
    var dayOfWeek: Day {
        return Day(rawValue: self.day)!
    }
    
    var repeated: Repeat {
        return Repeat(rawValue: self.repeat)!
    }
}