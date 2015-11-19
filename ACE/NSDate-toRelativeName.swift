//
//  NSDate.swift
//  ARC
//
//  Created by Andrew Sage on 09/11/2015.
//  Copyright © 2015 David Morrison. All rights reserved.
//

import UIKit
import Foundation
extension NSDate {
    func toRelativeName() -> String {
        var name = self.toString()
        if isToday() {
            name = "Today"
        } else if isYesterday() {
            name = "Yesterday"
        } else if isThisWeek() {
            name = self.weekdayToString()
        } else if isLastWeek() {
            name = "Last week"
        } else {
            name = self.toString()
        }
        return name
    }
    
    func compareTime(other :NSDate) -> NSComparisonResult {
        let cal = NSCalendar.currentCalendar()
        var flags: NSCalendarUnit = [.Hour, .Minute]
        let componentsThis = cal.components(flags, fromDate: self)
        componentsThis.day = 1
        componentsThis.month = 1
        componentsThis.year = 2015
        
        let componentsOther = cal.components(flags, fromDate: other)
        componentsOther.day = 1
        componentsOther.month = 1
        componentsOther.year = 2015
        
        let thisDate = cal.dateFromComponents(componentsThis)
        let otherDate = cal.dateFromComponents(componentsOther)
        
        return thisDate!.compare(otherDate!)
    }
}
