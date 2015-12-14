//
//  Appointment.swift
//  ARC
//
//  Created by David Morrison on 04/12/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//
import Foundation
import RealmSwift
import UIKit

class AppointmentActivity: Object, Activity {
    dynamic var id = "" 
    dynamic var title = ""
    dynamic var dateTime = NSDate()
    dynamic var address = ""
    dynamic var city = ""
    dynamic var postcode = ""
    dynamic var notes = ""
    
    static override func primaryKey() -> String? {
        return "id"
    }
    
    var name: String {
        // print(title)
        return title
    }
    var desc: String { return notes }
    
    var start: NSDate { return dateTime }
    var end: NSDate { return dateTime }
    var `repeat`: Repeat { return Repeat.none }
    
    var url: String? { return "" }
    var venue: Venue? { return nil }
    
    var attending: Bool {
        get { return true }
        set { /* do nothing */ }
    }
    var color: UIColor { get { return aceColors[AceColor.Yellow]! } }
    
    func includeOnDate(date: NSDate) -> Bool {
        let d = CVDate(date: dateTime)
        return d.day == date.day() && d.month == date.month && d.year == date.year
    }
}
    